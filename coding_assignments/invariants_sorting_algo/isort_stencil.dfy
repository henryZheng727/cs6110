predicate sorted(a:seq<int>)
{forall i,j :: 0 <=  i < j  < |a| ==> a[i] <= a[j] }

method InsertionSort(a:array<int>)
  modifies a
  requires a.Length >= 2
  ensures sorted(a[..])
  ensures multiset(a[..]) == multiset(old(a[..]))
{
  var x := 1;
  while x < a.Length
    invariant 1 <= x <= a.Length
    // TODO fill in here
  {
    var d := x;
    while d >= 1 && a[d-1] > a[d]
      // TODO fill in here
    {
      a[d-1],a[d] := a[d], a[d-1];
      d := d-1;
    }
    x := x+1;
  }
}