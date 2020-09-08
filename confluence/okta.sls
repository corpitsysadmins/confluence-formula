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
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
      
{% endif -%}

{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml->login.url:
  xml.value_present:
    - name: {{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml
    - xpath: ./parameters/init-param[param-name='login.url']/param-value
    - value: {{ okta.login_url }}
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
    
{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml->logout.url:
  xml.value_present:
    - name: {{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml
    - xpath: ./parameters/init-param[param-name='logout.url']/param-value
    - value: {{ okta.logout_url }}
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
    
#{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml->remove_authenticators:
#  xml.value_absent:
#    - name: {{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml
#    - xpath: ./authenticator
#    - exceptions:
#        - ./authenticator[@class='com.atlassian.confluence.authenticator.okta.OktaConfluenceAuthenticator30']
#    - require:
#      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml->okta_authenticator:
  xml.value_present:
    - name: {{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml
    - xpath: ./authenticator[@class='com.atlassian.confluence.authenticator.okta.OktaConfluenceAuthenticator30']/init-param[param-name='okta.config.file']/param-value
    - value: {{ confluence.install_path }}/conf/okta-config-confluence.xml
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running
        

#{{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml->login-url-strategy:
#  xml.value_present:
#    - name: {{ confluence.install_path }}/confluence/WEB-INF/classes/seraph-config.xml
#    - xpath: ./login-url-strategy[@class='com.atlassian.confluence.authenticator.okta.OktaConfluenceLoginUrlStrategy']
#    - value: ""
#    - require:
#      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{{ confluence.install_path }}/confluence/okta_acs.jsp:
  file.managed:
    - contents: |
        {{ okta.okta_acs_jsp | indent(8) }}
    - user: {{ confluence.user_name }}
    - group: {{ confluence.user_name }}
    - mode: 640
    - require:
      - confluence_installation
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
    - require:
      - confluence_installation
#    - require_in:
#      - confluence_running
#    - watch_in:
#      - confluence_running

{%- else -%}

#remove Okta stuff

{%- endif %}

{%- endif %}