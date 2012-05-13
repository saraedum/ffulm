#!/usr/bin/perl

use vars qw/ %opt /;

use File::Basename;
my $script_dir = dirname(__FILE__);

require "$script_dir/ffulm.inc";

sub init(){
        use Getopt::Std;
        my $opt_string = 'hH:m:';
        getopts( "$opt_string", \%opt ) or usage();
        usage() if $opt{h};
}

sub usage(){
	print STDERR << "EOF";
usage: $0 [-h] [-m mountpoint] [-H host]

	-h            : print this help message
	-H host       : target host (default: 172.17.1.1)
	-m mountpoint : mount point (default: $script_dir/../etc/)
EOF
	exit(1);
}

init();

$host = $opt{H} if $opt{H};
$mountpoint = $opt{m}?$opt{m}:"$script_dir/../etc/";

$opt{X}=1;

run("sshfs -o nonempty -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root\@$host:/etc/ $mountpoint");
