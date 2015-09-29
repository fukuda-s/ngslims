FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject
{% for d in seqlanes %}
{% set index = '' %}
{% set description = '' %}
{% if not d.slib.oligobarcodeA is empty and d.slib.oligobarcodeB_id is empty %}
{% set index = d.oa.barcode_seq %}
{% set description = d.st.name ~ d.oa.name %}
{% else %}
{% set index = d.oa.barcode_seq ~ '-' ~ d.ob.barcode_seq %}
{% set description = d.st.name ~ d.oa.name ~ d.ob.name %}
{% endif %}
{% set operator = '' %}
{% if not d.p.pi_user_id is 0 %}
{% set operator = d.u.lastname %}
{% endif %}
{{ d.fc.name }},{{ d.slane.number }},{{ d.slib.name }},{{ d.s.Organisms.name }},{{ index }},{{ description }},{{ d.slane.is_control }},{{ d.slib.Protocols.name }},{{ operator }},{# {{ d.p.name }} #}
{% endfor %}