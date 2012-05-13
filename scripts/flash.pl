#!/usr/bin/perl

use vars qw/ %opt /;

use File::Basename;
my $script_dir = dirname(__FILE__);

require "$script_dir/ffulm.inc";

my $model = "undefined";

sub init(){
        use Getopt::Std;
        my $opt_string = 'hs:v:m:H:X';
        getopts( "$opt_string", \%opt ) or usage();
	$model = $opt{m}?$opt{m}:"undefined";
        usage() if $opt{h};
}

my @models = ("lafonera", "wr741nd", "wr1043nd");

my %squashfs = (undefined => 'depends on the chosen model',
                lafonera => "$script_dir/../openwrt/openwrt-atheros-root.squashfs",
                wr1043nd => "$script_dir/../openwrt/openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-sysupgrade.bin",
                wr741nd => "$script_dir/../openwrt/openwrt-ar71xx-generic-tl-wr741nd-v4-squashfs-sysupgrade.bin",);

my %vmlinux = (undefined => 'depends on the chosen model',
               lafonera => "$script_dir/../openwrt/openwrt-atheros-vmlinux.lzma",
               wr741nd => undef,
               wr1043nd => undef);

sub usage(){
	print STDERR << "EOF";
usage: $0 [-h] -m model [-s squashfs] [-v vmlinux] [-H host] [-X]

	-h          : print this help message
	-m model    : the router model (one of: @models)
	-s squashfs : squashfs image (default: $squashfs{$model})
	-v vmlinux  : vmlinux image (default: $vmlinux{$model})
	-H host     : target host (default: 172.17.1.1)
	-X          : do flash the router (without this only prints what it would be doing)
EOF
	exit(1);
}

init();

my $squashfs = $opt{s}?$opt{s}:$squashfs{$model};
my $vmlinux = $opt{v}?$opt{v}:$vmlinux{$model};
$host = $opt{H} if $opt{H};

usage unless $model ~~ @models;
if ($model eq "lafonera"){
	# this might not work: http://wiki.openwrt.org/toh/fon/fonera#upgrading.openwrt.from.within.a.running.openwrt.installation
	copy($squashfs,"/tmp/squashfs");
	copy($vmlinux,"/tmp/vmlinux");
	my $script=<<EOF;
set -e
cd /tmp
/sbin/mtd -e vmlinux.bin.l7 write vmlinux vmlinux.bin.l7
/sbin/mtd -e rootfs write squashfs rootfs
reboot
EOF
	run_remote($script);
}elsif ($model ~~ ("wr741nd", "wr1043nd")){
	copy($squashfs,"/tmp/squashfs");
	usage() if $opt{v};
	my $script=<<EOF;
set -e
cd /tmp
/sbin/mtd -r write squashfs firmware
EOF
	run_remote($script);
}else{
	usage();
}

print STDERR "Nothing actually happened because you did not supply '-X'.\n" unless $opt{X};
