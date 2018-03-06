use strict;
use warnings;

use Test::More;
use Test::Quattor qw(hypervisor);
use Test::Quattor::Object;
use Test::MockModule;

use NCM::Component::openstack;
use NCM::Component::OpenStack::Nova;

use helper;
use Test::Quattor::TextRender::Base;

my $caf_trd = mock_textrender();
my $obj = Test::Quattor::Object->new();

my $mockos = Test::MockModule->new('NCM::Component::OpenStack::Nova');
$mockos->mock("read_ceph_key", sub { return 'AAAAABBBXXXXYYYZZZZ=='; } );

my $cmp = NCM::Component::openstack->new("hypervisor", $obj);
my $cfg = get_config_for_profile("hypervisor");



ok($cmp->Configure($cfg), "Configure hypervisor returns success");
ok(!exists($cmp->{ERROR}), "No errors found in hypervisor normal execution");


# Verify Nova configuration file
my $fh = get_file("/etc/nova/nova.conf");
isa_ok($fh, "CAF::FileWriter", "nova.conf hypervisor CAF::FileWriter instance");
like("$fh", qr{^\[DEFAULT\]$}m, "nova.conf hypervisor has expected content");

# Verify Neutron configuration file
$fh = get_file("/etc/neutron/neutron.conf");
isa_ok($fh, "CAF::FileWriter", "neutron.conf hypervisor CAF::FileWriter instance");
like("$fh", qr{^\[DEFAULT\]$}m, "neutron.conf hypervisor has expected content");

# Verify Neutron/linuxbridge configuration file
$fh = get_file("/etc/neutron/plugins/ml2/linuxbridge_agent.ini");
isa_ok($fh, "CAF::FileWriter", "inuxbridge_agent.ini hypervisor CAF::FileWriter instance");
like("$fh", qr{^\[linux_bridge\]$}m, "inuxbridge_agent.ini hypervisor has expected content");

diag "all hypervisor history commands ", explain \@Test::Quattor::command_history;

ok(command_history_ok([
        'service openstack-nova-compute restart',
        'service neutron-linuxbridge-agent restart',
    ]), "expected hypervisor commands run");

command_history_reset();

done_testing();
