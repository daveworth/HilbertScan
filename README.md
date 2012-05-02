# Hilbert Scan

A Hilbert Scan is a path to traverse all points in a 2^n x 2^n square in a path that resembles a [Hilbert Curve](http://en.wikipedia.org/wiki/Hilbert_curve).  Producing such a path was surprisingly tricky!

## Use

To use this Module simple `use HilbertScan;` and call `hilbert_scan(log2_side_length)` where `log2_side_length` is `n` in `2^n` described previously.  This  function will return an array-ref of array-refs which each ref is the (x,y) pair of the coordinate of that step through the grid.
