{% for role in salt.grains.get('roles', []) %}
{% if role == 'airflow' %}

include:
  - airflow.setup_airflow

{% endif %}
{% endfor %}

