{%- from "./defaults/map.jinja" import confluence with context -%}
{%- from "confluence/defaults/okta.jinja" import okta with context -%}

{% if (okta is defined) and (okta.use is defined) -%}

{% if okta.use | to_bool -%}

{% if okta.configuration is defined -%}

{{ confluence.install_path }}/conf/okta-config-confluence.xml:
  file.managed:
    - contents: |
        {{ okta.configuration | indent(8) }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
      
{% endif -%}

{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml:
  xml.value_present:
    - xpath: (/security-config/parameters[init-param='login.url'])[1]/param-value[1]
    - value: {{ okta.login_url }}
#2. Then, you need to update your [confluence_webdir]/WEB-INF/classes/seraph-config.xml

{{ confluence.install_path }}/confluence/okta_acs.jsp:
  file.managed:
    - contents: |
        {{ okta.okta_acs_jsp | indent(8) }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{{ confluence.install_path }}/confluence/WEB-INF/lib/{{ okta.okta_confluence_jar }}:
  file.managed:
    - source: https://dev.okta.com/static/toolkits/{{ okta.okta_confluence_jar }}
    - skip_verify: true
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{%- else -%}

#remove Okta stuff

{%- endif %}

{%- endif %}