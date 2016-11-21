install-etcd:
  pkg.installed:
    - names:
      - epel-release
      - etcd
  cmd.run:
    - name: mkdir  -p /data/etcd && chown -R etcd:etcd /data/etcd

config-etcd:
  file.managed:
    - name: /etc/etcd/etcd.conf
    - source: salt://etcd/file/etcd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      CLUSTER_IP1: {{ pillar['etcd']['CLUSTER_IP1'] }}
      CLUSTER_IP2: {{ pillar['etcd']['CLUSTER_IP2'] }}
      CLUSTER_IP3: {{ pillar['etcd']['CLUSTER_IP3'] }}
      MY_IP: {{ grains['fqdn_ip4'][0] }}
      MY_HOSTNAME: {{ grains['fqdn'] }}
etcd-server:
  service.running:
    - name: etcd
    - enable: True
    - watch:
      - file: /etc/etcd/etcd.conf
    - require:
      - cmd: install-etcd
      - file: config-etcd   
