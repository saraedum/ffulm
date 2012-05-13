our $host = "192.168.1.1";

sub run{
	my ($command,) = @_;
	if($opt{X}){
		die("command $command failed") if(system($command));
	}else{
		print "$command\n";
	}
}

sub copy{
	my ($from,$to) = @_;
	die("file not found $from") unless -e $from;
	run("scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $from root\@$host:$to");
}

sub run_remote{
	my ($script,) = @_;
	run("ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root\@$host 'sh -s' <<'EOF' $script\nEOF");
}

return 1;
