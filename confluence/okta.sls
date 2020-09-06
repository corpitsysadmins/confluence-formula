{%- from "./defaults/map.jinja" import confluence with context -%}
{%- from "confluence/defaults/okta.jinja" import okta with context -%}

{% if (okta is defined) and (okta.use is defined) -%}

{% if okta.use | to_bool -%}

{% if okta.configuration is defined -%}

{{ confluence.install_path }}/conf/okta-config-confluence.xml:
  file.managed:
    - source: salt://confluence/generic-template.jinja
    - template: jinja
    - context: 
        root_element: {{ okta.configuration }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
      
{% endif -%}

#2. Then, you need to update your [confluence_webdir]/WEB-INF/classes/seraph-config.xml

#3. Create new file okta_acs.jsp in your [confluence_install_dir]/confluence folder, then paste this code into it

#4. After that, you need to copy okta-confluence.jar to the [confluence_webdir]/WEB-INF/lib directory

{%- else -%}

#remove Okta stuff

{%- endif %}

{%- endif %}