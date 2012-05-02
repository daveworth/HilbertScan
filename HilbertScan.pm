package HilbertScan;
use strict;
use warnings;
use Carp;

=head1 Hilbert Scan

=head1 Author

Copyright (C) 2010 by David Worth ()

$Id$

=head1 Functional Documentation

=over

=item hilbert_scan($log2_side_length)

returns a hilbert-scan path (array-ref of array-refs where each ref is the (x,y) 
coordinates of the n-th entry of the path through the square)
 
=cut  
sub get_path($) {
  my ($log2_side_len) = @_;
  my $path = (&hilbert_scan_recursive(&twotwoN_square_coords($log2_side_len), 0, 0))[0];
  return $path;
}

# orientations: 0 (facing up), 3 (facing left), 1 (facing right), 2 (facing down)
sub hilbert_scan_recursive($$$$$) {
  my ($x1, $y1, $x2, $y2, $count, $orient) = @_;
  my @retvals = ();

  if (($x2 - $x1) != ($y2 - $y1)) {
    cluck("Region is not square!");
  } else {
    if (($x2 - $x1 == 1) && ($y2 - $y1 == 1)) {
      #print "Got ($x1, $y1) and ($x2, $y2) -> $orient\n";
      if ($orient == 0) {
        push @retvals, [$x1, $y1, $count++];
        push @retvals, [$x1, $y2, $count++];
        push @retvals, [$x2, $y2, $count++];
        push @retvals, [$x2, $y1, $count++];
      } elsif ($orient == 3) {
        push @retvals, [$x1, $y1, $count++];
        push @retvals, [$x2, $y1, $count++];
        push @retvals, [$x2, $y2, $count++];
        push @retvals, [$x1, $y2, $count++];
      } elsif ($orient == 2) {
        push @retvals, [$x2, $y2, $count++];
        push @retvals, [$x2, $y1, $count++];
        push @retvals, [$x1, $y1, $count++];
        push @retvals, [$x1, $y2, $count++];
      } elsif ($orient == 1) {
        push @retvals, [$x2, $y2, $count++];
        push @retvals, [$x1, $y2, $count++];
        push @retvals, [$x1, $y1, $count++];
        push @retvals, [$x2, $y1, $count++];
      }
    } else {
      my ($new_width, $new_height) = (int(($x2-$x1)/2), int(($y2-$y1)/2));
      my ($ret1, $ret2, $ret3, $ret4);

      # upper-left quadrant
      ($ret1, $count) = &hilbert_scan_recursive($x1, $y1, $x1+$new_width, $y1+$new_height, $count, &rotate_left($orient));

      # lower-left quadrant
      ($ret2, $count) = &hilbert_scan_recursive($x1, $y1+$new_height+1, $x1+$new_width, $y2, $count, $orient);

      # lower-right quadrant
      ($ret3, $count) = &hilbert_scan_recursive($x1+$new_width+1, $y1+$new_height+1, $x2, $y2, $count, $orient);

       # upper-right quadrant
      ($ret4, $count) = &hilbert_scan_recursive($x1+$new_width+1, $y1, $x2, $y1+$new_height, $count, &rotate_right($orient));

      push @retvals, @$ret1, @$ret2, @$ret3, @$ret4;
    }
  }

  return (\@retvals, $count);
}

sub twotwoN_square_coords($) {
  my ($log2_side_len) = @_;

  return (0, 0, (2**$log2_side_len)-1, (2**$log2_side_len)-1);
}

sub rotate_right($) { return ((shift)+1)%4; }
sub rotate_left($)  { return ((shift)-1)%4; }

1;
