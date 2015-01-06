seq_split
=========

       splits a sequence into equal sized chunks with an optional overlappings

SYNOPSIS
========

       lwc_split_seq -c 10000 [-o 1000] -f seq.in

DESCRIPTION
===========

       The script will split sequences into chunks

       Mandatory Options:
`
         -c  Desired length of the resulting sequences.
         -f  Input file (must be FASTA format).
         -r  Output file (FASTA format).
`

       Special Options:
`
         -o  Overlapping length between the resulting sequences.
`

AUTHORS
=======
         Wenchao Lin <lt>linwenchao@yeah.net <gt>

