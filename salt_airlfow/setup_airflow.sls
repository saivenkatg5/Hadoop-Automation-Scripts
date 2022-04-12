airflow:
  user.present:
    - fullname: airflow 
    - shell: /bin/bash 
    - home: /home/airflow 

add_sudoers_entry:
  file.append:
    - name: /etc/sudoers
    - text: "airflow ALL=(ALL) NOPASSWD: ALL"

airflow_env:
   environ.setenv:
     - value:
         LC_ALL:C.UTF-8
         LC_CTYPE:en_US.UTF-8

pip_install:
  pkg.installed: 
    - refresh: True
    - pkgs:
      - python-pip
      - python3-dev
      - default-libmysqlclient-dev
      - build-essential
      - libsasl2-dev
      - libffi-dev
      - autoconf
      - libtool
      - pkg-config
      - python-opengl
      - python-pil
      - python-pyrex
      - python-pyside.qtopengl
      - idle-python2.7
      - qt4-dev-tools
      - qt4-designer
      - libqtgui4
      - libqtcore4
      - libqt4-xml
      - libqt4-test
      - libqt4-script
      - libqt4-network
      - libqt4-dbus
      - python-qt4
      - python-qt4-gl
      - libgle3
      - python-dev
      - libssl-dev
      - libsasl2-dev
      - gcc
      - python-dev
      - libkrb5-dev
      - libxml2-dev
      - libxslt1-dev
      - libssl-dev
      - libffi-dev

upgrade_pip:
  cmd.run:
    - name: pip install --upgrade pip==20.2.3

packages_template:
  file.managed:
    - name: /tmp/constraints.txt
    - mode: 755
    - user: root
    - group: root 
    - source: salt://airflow/files/constraints.txt

install_dependencies:
  cmd.run: 
    - name: pip install -r /tmp/constraints.txt

remove_python_openssl:
  pkg.removed:
    - name: python-openssl

acess_airflow:
  file.directory:
    - name: /usr/local/lib/python2.7/dist-packages
    - mode: 755
    - recurse:
      - mode

env_variable:
  file.managed:
    - name: /etc/environment
    - user: root
    - group: root 
    - source: salt://airflow/files/environment 

post_checks:
   cmd.run:
     - runas: airflow
     - names: 
       - airflow initdb
       - airflow webserver -p 8080 -D
       - airflow scheduler -D

