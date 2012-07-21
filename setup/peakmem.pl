#!/usr/bin/perl -w

# from http://tstarling.com/blog/2010/06/measuring-memory-usage-with-strace

# changes:
# - show only max mem, and use \r to animate display

my $cmd;

$machine = `uname -m`;
chomp($machine);

if ( $machine eq 'x86_64' ) {
	$cmd = 'strace -e trace=mmap,munmap,brk ';
} else {
	$cmd = 'strace -e trace=mmap,mmap2,munmap,brk ';
}

for my $arg (@ARGV) {
	$arg =~ s/'/'\\''/g;
	$cmd .= " '$arg'";
}
$cmd .= ' 2>&1 >/dev/null';

open( PIPE, "$cmd|" ) or die "Cannot execute command \"$cmd\"\n";

my $currentSize = 0;
my $maxSize = 0;
my %maps;
my $topOfData = undef;
my ($addr, $length, $prot, $flags, $fd, $pgoffset);
my $newTop;
my $error = '';

# turn on output flushing after every write
$|++;

while ( <PIPE> ) {
	if ( /^mmap2?\((.*)\) = (\w+)/ ) {
		@params = split( /, ?/, $1 );
		($addr, $length, $prot, $flags, $fd, $pgoffset) = @params;
		if ( $addr eq 'NULL' && $fd == -1 ) {
			$maps{$2} = $length;
			$currentSize += $length;
		}
	} elsif ( /^munmap\((\w+),/ ) {
		if ( defined( $maps{$1} )  ) {
			$currentSize -= $maps{$1};
			undef $maps{$1};
		}
	} elsif ( /^brk\((\w+)\)\s*= (\w+)/ ) {
		$newTop = hex( $2 );
		if ( hex( $1 ) == 0 or !defined( $topOfData ) ) {
			$topOfData = $newTop;
		} else {
			$currentSize += $newTop - $topOfData;
			$topOfData = $newTop;
		}
	} else {
		$error .= $_;
	}

	if ( int( ( $currentSize - $maxSize ) / 1048576 ) > 0 ) {
		$maxSize = $currentSize;
		printf( "\r%d MB", $maxSize / 1048576 );
	}
}
printf( "\r%d MB  \n", $maxSize / 1048576 ); 
close( PIPE );
if ( $? ) {
	print $error;
}

