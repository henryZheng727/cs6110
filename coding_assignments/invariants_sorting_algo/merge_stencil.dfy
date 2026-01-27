
method MergeSort(a1:array<int>) returns (a2:array<int>)
  requires a1.Length > 0
  ensures forall k:: forall l:: 0 <= k < l < a2.Length ==> a2[k] <= a2[l]
{
  a2 := ms(a1, 0, a1.Length-1);
  return;
}

method ms(a1:array<int>, l:int, u:int) returns (a:array<int>)
requires 0 <= l < a1.Length
requires 0 <= u < a1.Length
decreases (u - l)
ensures a1.Length == a.Length
ensures forall i1:: forall i2::
          l <= i1 < i2 <= u ==> a[i1] <= a[i2]
{
  a := new int[a1.Length];
  if (l >= u)
  {
    return;
  }
  else
  {
    var m:int := (l + u) / 2; // means that l == m is possible
    a := ms(a, l, m); // sort [l -- m]
    a := ms(a, m+1, u); // sort [m+1 -- u]
    a := merge(a, l, m, u); // maybe will go away when we finish fixing merge
    return;
  }
}

method merge(a1:array<int>, l:int, m:int, u:int) returns (a:array<int>)
requires 0 <= l <= m < u  < a1.Length
// TODO fill in here
{
  a := new int[a1.Length]; // output array
  assert forall k:: 0 <= k < a1.Length ==> a[k] == a1[k];
  var buf := new int[u-l+1]; // temp space
  var i:int := l; // beginning of 1st array
  var j:int := m + 1; // beginning of 2nd array
  assert (j < a1.Length);
  var k:int := 0; // index to temp space (buf)
  while (k < u-l+1)
  // TODO fill in here
  {
    if (i > m)
    {
      // done copying elements in first half
      // if i exceeds the middle index, store in temp space
      buf[k] := a[j];
      j := j + 1;
    }
    else if (j > u)
    {
      buf[k] := a[i];
      i := i + 1;
    }
    else if (a[i] <= a[j])
    {
      buf[k] := a[i];
      i := i + 1;
    }
    else
    {
      buf[k] := a[j];
      j := j + 1;
    }
    k := k + 1;
  }

  k := 0;
  while (k < u-l+1)
  // TODO fill in here
  {
    a[l + k] := buf[k];
    k := k + 1;
  }
}

