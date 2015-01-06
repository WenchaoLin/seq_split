#!/usr/bin/perl -w

# Modules, pragmas and variables to use
use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use vars qw($opt_c $opt_o $opt_r $opt_f $result_file);
use strict;

=head1 NAME

lwc_split_seq - splits a sequence into equal sized chunks with an optional
            overlapping range

=head1 SYNOPSIS

lwc_split_seq -c 10000 [-o 1000] -f seq.in

=head1 DESCRIPTION 

The script will split sequences into chunks

Mandatory Options:

  -c  Desired length of the resulting sequences.
  -f  Input file (must be FASTA format).
  -r  Output file (FASTA format).

Special Options:

  -o  Overlapping length between the resulting sequences.

=head1 AUTHORS

  Wenchao Lin <lt>linwenchao@yeah.net <gt>

=cut

# Gets options from the command line
GetOptions qw(-c=i -o:i -f=s -r=s);

# If no mandatory options are given prints an error and exits
if (!$opt_c) {
    print "ERROR: No chunk size (-c) has been specified.\n" and exit();
} elsif (!$opt_f) {
    print "ERROR: No FASTA file (-f) has been specified.\n" and exit();
} elsif (!$opt_r) {
    print "ERROR: No result file (-r) has been specified.\n" and exit();
}

# Declares offset size
my $offset = $opt_o ? $opt_o : "0";

# Opens the FASTA file
my $in = Bio::SeqIO->new(
    -file   => "$opt_f",
    -format => "Fasta",
);
print "==> Opening FASTA file:\t\t\t\t$opt_f\n";


my $out = Bio::SeqIO->new(
	-file => ">$opt_r",
	-format => "fasta",
	);
print "==> Result FASTA file:\t\t\t\t$opt_r\n";


my $processed_nums;

# Reads the next sequence object
while (my $seq = $in->next_seq()) {
    $processed_nums+=1;

    # Reads the ID for the sequence and prints it
    my $id = $seq->id();

    # Reads the description for the sequence and prints it
    my $desc = $seq->desc();

    # Gets sequence length and prints it
    my $seq_length = $seq->length();

    # Loops through the sequence
    for (my $i = 1; $i < $seq_length; $i += $opt_c) {
        my $end = (($i + $opt_c) > $seq_length) ? ($seq_length + 1) : ($i + $opt_c);
        my $id = $seq->id() . "_${i}_".($end - 1);

        my $trunc_seq = $seq->trunc($i, $end - 1);
        $trunc_seq->id($id);
        $out->write_seq($trunc_seq);

        # Decreases the $i value with the offset value
        $i -= (($i + $opt_c >$seq_length) ? 0 : ($offset));
    }
    print "==> Processing: $processed_nums\r";

}
print "\n==> All Done!\n";


__END__
