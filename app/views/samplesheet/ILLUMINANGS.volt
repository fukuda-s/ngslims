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
{% endfor <!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

%}