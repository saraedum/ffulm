#!/usr/bin/perl

use vars qw/ %opt /;

use File::Basename;
my $script_dir = dirname(__FILE__);

require "$script_dir/ffulm.inc";

sub init(){
        use Getopt::Std;
        my $opt_string = 'hTd:r:a:s:S:H:X';
        getopts( "$opt_string", \%opt ) or usage();
        usage() if $opt{h};
}

sub usage(){
	print STDERR << "EOF";
usage: $0 [-h] [-T] [-d dsa] [-r rsa] [-a authorized_keys] [-s shadow] [-S shadow-]  [-H host] [-X]

	-h            : print this help message
	-T            : try to reset root password through telnet
	-d dss        : dropbear_dss_host_key (default: None)
	-r rsa        : dropbear_rsa_host_key (default: None)
	-a auth_keys  : authorized_keys (default: None)
	-s shadow     : shadow (default: None)
        -S shadow-    : shadow- (default: None)
	-H host       : target host (default: 172.17.1.1)
	-X            : do run the commands (without this only prints what it would be doing)

To reset everything from the repository, use $0 -d '$script_dir/../etc/dropbear/dropbear_dss_host_key' -r '$script_dir/../etc/dropbear/dropbear_rsa_host_key' -a '$script_dir/../etc/dropbear/authorized_keys' -s '$script_dir/../etc/shadow' -S '$script_dir/../etc/shadow-'
EOF
	exit(1);
}

init();

$host = $opt{H} if $opt{H};

if ($opt{T}){
	run("(sleep 1; echo passwd; sleep 1; echo vince27brown; sleep 1; echo vince27brown; sleep 1; echo 'echo Set root password to vince27brown'; sleep 1) | telnet $host || true");
}

copy($opt{a},"/etc/dropbear/authorized_keys") if($opt{a});
copy($opt{d},"/etc/dropbear/dropbear_dss_host_key") if($opt{d});
copy($opt{r},"/etc/dropbear/dropbear_rsa_host_key") if($opt{r});
copy($opt{s},"/etc/shadow") if($opt{s});
copy($opt{S},"/etc/shadow-") if($opt{S});

print STDERR "Nothing actually happened because you did not supply '-X'.\n" unless $opt{X};
