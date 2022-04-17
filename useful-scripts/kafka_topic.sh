#!/bin/bash

# Example: Topic file should be like this test_topic,3,3 ---> Topic Name,Partition count,Replication Factor 
# you can invoke a specific fucntion based upon requirement sh kafka-topic.sh  createKafkaTopic ---> scriptname functionname 


config()
{
zoo_server=$(cat /etc/kafka/conf/server.properties  | grep -w 'zookeeper.connect' | cut -d "=" -f2)
topic=$(echo "$i" | awk -F "," '{print $1}')
partitions=$(echo "$i" | awk -F "," '{print $2}')
replication=$(echo "$i" | awk -F "," '{print $3}')
retention="$1"
}

createKafkaTopic()
 {
   for i in  $(cat topic)
   do 
   config 
   echo "${topic}" "${partitions}" "${replication}"

   /usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --topic ${topic} --partitions ${partitions} --replication-factor ${replication} --zookeeper ${zoo_server}
   done

   }

retentionKafkaTopic()
  {
  for i in  $(cat topic)
  do
   config 	  
   echo "${topic}" "${retention}"

   /usr/hdp/current/kafka-broker/bin/kafka-configs.sh --alter --zookeeper ${zoo_server}  --add-config retention.ms=${retention}  --entity-name ${topic} --entity-type topics
   done

   }


describeKafkaTopic()
  {
for i in  $(cat topic)
  do
  config
  echo "${topic}"
  
  /usr/hdp/current/kafka-broker/bin/kafka-topics.sh --describe --topic ${topic} --zookeeper ${zoo_server} | head -1 
  done 
  }

"$@"
