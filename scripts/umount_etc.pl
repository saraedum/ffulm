#!/usr/bin/perl

use vars qw/ %opt /;

use File::Basename;
my $script_dir = dirname(__FILE__);

require "$script_dir/ffulm.inc";

sub init(){
        use Getopt::Std;
        my $opt_string = 'hm:';
        getopts( "$opt_string", \%opt ) or usage();
        usage() if $opt{h};
}

sub usage(){
	print STDERR << "EOF";
usage: $0 [-h] [-m mountpoint]

	-h            : print this help message
	-m mountpoint : mount point (default: $script_dir/../etc/)
EOF
	exit(1);
}

init();

$mountpoint = $opt{m}?$opt{m}:"$script_dir/../etc/";

$opt{X}=1;

run("fusermount -u $mountpoint");
