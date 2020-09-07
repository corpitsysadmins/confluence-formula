{%- from "./defaults/map.jinja" import confluence with context -%}

{% if (confluence is defined) and (confluence.use is defined) -%}

{% if confluence.use | to_bool -%}

confluence_installation:
  pkg.installed:
    - sources:
      - {{ confluence.package_name }}: {{ confluence.package_url }}

{% if confluence["confluence.cfg"] is defined -%}

{{ confluence.confluence_home }}/confluence.cfg.xml:
  file.managed:
    - source: salt://confluence/generic-xml-template.jinja
    - template: jinja
    - context: 
        root_element: {{ confluence["confluence.cfg"]|json }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{% endif -%}

{% if confluence.keystore_file is defined -%}
  
{{ confluence.install_path }}/conf/ssl_keystore.pkcs12:
  file.managed:
    - source: {{ confluence.keystore_file }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640

{% endif -%}

#confluence_running:  
#  service.running:
#    - name: {{ confluence.service_name }}
#    - enable: True
#    - require:
#      - confluence_installation

{%- else -%}

confluence_stopped:  
  service.dead:
    - name: {{ confluence.service_name }}
    - enable: False

confluence_removal:
  pkg.removed:
    - name: {{ confluence.package_name }}
    - require:
      - service: {{ confluence.service_name }}

{%- endif %}

{%- endif %}