use strict;
use warnings;
use Test::More;
use Test::Quattor qw(cluster);
use NCM::Component::Ceph::Luminous;
use clusterdata;

my $cfg = get_config_for_profile('cluster');
my $cmp = NCM::Component::Ceph::Luminous->new('ceph');
my $cl = NCM::Component::Ceph::Cluster->new($cfg, $cmp, $cmp->prefix());

my $hostname = 'ceph001';

my $dpp = "su - ceph -c /usr/bin/ceph-deploy gatherkeys";
my $gather1 = "$dpp ceph001.cubone.os";
my $gather2 = "$dpp ceph002.cubone.os";
my $gather3 = "$dpp ceph003.cubone.os";
my @gathers = ($gather1, $gather2, $gather3);
set_desired_output("/usr/bin/ceph -f json --cluster ceph status", $clusterdata::STATE);


# Totally new cluster
foreach my $gcmd (@gathers) {
    set_command_status($gcmd,1);
    set_desired_err($gcmd,'');
}
my $clustercheck = $cl->cluster_exists();
my $cmd;
foreach my $gcmd (@gathers) {
    $cmd = get_command($gcmd);
    ok(defined($cmd), "no cluster: gather had been tried");
}
ok(!$clustercheck, "no cluster, return 0");

done_testing();
