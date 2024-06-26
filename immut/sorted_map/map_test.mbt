// Copyright 2024 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

test "from_array" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
}

test "insert" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one")]
  inspect(m.debug_tree(), content="(3,three,(1,one,_,_),(8,eight,_,_))")?
  let m = m.insert(5, "five").insert(2, "two").insert(0, "zero").insert(
    1, "one_updated",
  )
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one_updated,(0,zero,_,_),(2,two,_,_)),(8,eight,(5,five,_,_),_))",
  )?
}

test "remove" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  let m = m.remove(1).remove(3)
  @assertion.assert_eq(m.debug_tree(), "(2,two,(0,zero,_,_),(8,eight,_,_))")?
}

test "lookup" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  @assertion.assert_eq(m.lookup(8), Some("eight"))?
  @assertion.assert_eq(m.lookup(2), Some("two"))?
  @assertion.assert_eq(m.lookup(4), None)?
}

test "member" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  @assertion.assert_eq(m.member(8), true)?
  @assertion.assert_eq(m.member(2), true)?
  @assertion.assert_eq(m.member(4), false)?
}

test "size" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  @assertion.assert_eq(m.size(), 5)?
  let m = m.remove(1).remove(3)
  @assertion.assert_eq(m.size(), 3)?
}

test "is_empty" {
  let m : Map[Int, Int] = empty()
  @assertion.assert_eq(m.is_empty(), true)?
  let m = m.insert(1, 1)
  @assertion.assert_eq(m.is_empty(), false)?
}

test "iter" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let mut s = ""
  m.iter(fn(k, v) { s = s + "(\(k),\(v))" })
  @assertion.assert_eq(s, "(0,zero)(1,one)(2,two)(3,three)(8,eight)")?
}

test "iteri" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let mut s = ""
  m.iteri(fn(i, k, v) { s = s + "(\(i),\(k),\(v))" })
  @assertion.assert_eq(s, "(0,0,zero)(1,1,one)(2,2,two)(3,3,three)(4,8,eight)")?
}

test "map" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let n = m.map(fn(v) { v + "X" })
  @assertion.assert_eq(
    n.debug_tree(),
    "(3,threeX,(1,oneX,(0,zeroX,_,_),(2,twoX,_,_)),(8,eightX,_,_))",
  )?
}

test "map_with_key" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let n = m.map_with_key(fn(k, v) { "\(k)-\(v)" })
  @assertion.assert_eq(
    n.debug_tree(),
    "(3,3-three,(1,1-one,(0,0-zero,_,_),(2,2-two,_,_)),(8,8-eight,_,_))",
  )?
}

test "fold" {
  let m = Map::[("a", 1), ("b", 2), ("c", 3), ("d", 4), ("e", 5)]
  @assertion.assert_eq(m.fold(fn(acc, v) { acc + v }, init=0), 15)?
}

test "foldl_with_key" {
  let m = Map::[("a", 1), ("b", 2), ("c", 3), ("d", 4), ("e", 5)]
  @assertion.assert_eq(
    m.foldl_with_key(fn(acc, k, v) { acc + k + v.to_string() }, init=""),
    "a1b2c3d4e5",
  )?
}

test "foldr_with_key" {
  let m = Map::[("a", 1), ("b", 2), ("c", 3), ("d", 4), ("e", 5)]
  @assertion.assert_eq(
    m.foldr_with_key(fn(acc, k, v) { acc + k + v.to_string() }, init=""),
    "e5d4c3b2a1",
  )?
}

test "filter" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let fm = m.filter(fn(v) { v.length() > 3 })
  @assertion.assert_eq(fm.debug_tree(), "(3,three,(0,zero,_,_),(8,eight,_,_))")?
}

test "filter_with_key" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let fm = m.filter_with_key(fn(k, v) { k > 3 && v.length() > 3 })
  @assertion.assert_eq(fm.debug_tree(), "(8,eight,_,_)")?
}

test "to_array" {
  let m = Map::[(1, "one"), (2, "two"), (3, "three")]
  @assertion.assert_eq(
    m.as_iter().collect(),
    [(1, "one"), (2, "two"), (3, "three")],
  )?
}

test "keys" {
  let m = Map::[(1, "one"), (2, "two"), (3, "three")]
  @assertion.assert_eq(m.keys(), [1, 2, 3])?
}

test "elems" {
  let m = Map::[(1, "one"), (2, "two"), (3, "three")]
  @assertion.assert_eq(m.elems(), ["one", "two", "three"])?
}

test "singleton" {
  let m = singleton(3, "three")
  @assertion.assert_eq(m.debug_tree(), "(3,three,_,_)")?
}

test "empty" {
  let m : Map[Int, Int] = empty()
  @assertion.assert_eq(m.debug_tree(), "_")?
}

test "split_max" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  @assertion.assert_eq(
    m.debug_tree(),
    "(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  let (k, v, r) = m.split_max()
  @assertion.assert_eq(k, 8)?
  @assertion.assert_eq(v, "eight")?
  @assertion.assert_eq(
    r.debug_tree(),
    "(2,two,(1,one,(0,zero,_,_),_),(3,three,_,_))",
  )?
}

test "split_min" {
  let m = Map::[(3, "three"), (8, "eight"), (2, "two"), (1, "one"), (0, "zero")]
  @assertion.assert_eq(
    m.debug_tree(),
    "(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  let (k, v, r) = m.split_min()
  @assertion.assert_eq(k, 0)?
  @assertion.assert_eq(v, "zero")?
  @assertion.assert_eq(
    r.debug_tree(),
    "(3,three,(1,one,_,(2,two,_,_)),(8,eight,_,_))",
  )?
}

test "glue" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  @assertion.assert_eq(
    m.debug_tree(),
    "(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  let (l, r) = match m {
    Tree(_, l, r, ..) => (l, r)
    _ => abort("unreachable")
  }
  let m = l.glue(r)
  @assertion.assert_eq(
    m.debug_tree(),
    "(2,two,(1,one,(0,zero,_,_),_),(8,eight,_,_))",
  )?
}

test "op_equal" {
  let m1 = Map::[
    (3, "three"),
    (8, "eight"),
    (1, "one"),
    (2, "two"),
    (0, "zero"),
  ]
  let m2 = Map::[
    (3, "three"),
    (8, "eight"),
    (1, "one"),
    (2, "two"),
    (0, "zero"),
  ]
  let m3 = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two")]
  @assertion.assert_eq(m1 == m2, true)?
  @assertion.assert_eq(m1 == m3, false)?
}

test "debug_write" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let buffer = Buffer::make(0)
  m.debug_write(buffer)
  @assertion.assert_eq(
    buffer.to_string(),
    "Map::[(0, \"zero\"), (1, \"one\"), (2, \"two\"), (3, \"three\"), (8, \"eight\")]",
  )?
}

test "as_iter" {
  let buf = Buffer::make(20)
  let map = Map::[(1, "one"), (2, "two"), (3, "three")]
  map.as_iter().iter(
    fn(e) {
      let (k, v) = e
      buf.write_string("[\(k)-\(v)]")
    },
  )
  inspect(buf, content="[1-one][2-two][3-three]")?
  buf.reset()
  map.as_iter().take(2).iter(
    fn(e) {
      let (k, v) = e
      buf.write_string("[\(k)-\(v)]")
    },
  )
  inspect(buf, content="[1-one][2-two]")?
}

test "insert" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one")]
  inspect(m.debug_tree(), content="(3,three,(1,one,_,_),(8,eight,_,_))")?
  let m = m.insert(5, "five").insert(2, "two").insert(0, "zero").insert(
    1, "one_updated",
  )
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one_updated,(0,zero,_,_),(2,two,_,_)),(8,eight,(5,five,_,_),_))",
  )?
}

test "remove" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  inspect(
    m.debug_tree(),
    content="(3,three,(1,one,(0,zero,_,_),(2,two,_,_)),(8,eight,_,_))",
  )?
  let m = m.remove(1).remove(3)
  @assertion.assert_eq(m.debug_tree(), "(2,two,(0,zero,_,_),(8,eight,_,_))")?
}

test "filter" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let fm = m.filter(fn(v) { v.length() > 3 })
  @assertion.assert_eq(fm.debug_tree(), "(3,three,(0,zero,_,_),(8,eight,_,_))")?
}

test "filter_with_key" {
  let m = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two"), (0, "zero")]
  let fm = m.filter_with_key(fn(k, v) { k > 3 && v.length() > 3 })
  @assertion.assert_eq(fm.debug_tree(), "(8,eight,_,_)")?
}

test "to_array" {
  let m = Map::[(1, "one"), (2, "two"), (3, "three")]
  @assertion.assert_eq(m.to_array(), [(1, "one"), (2, "two"), (3, "three")])?
}

test "op_equal" {
  let m1 = Map::[
    (3, "three"),
    (8, "eight"),
    (1, "one"),
    (2, "two"),
    (0, "zero"),
  ]
  let m2 = Map::[
    (3, "three"),
    (8, "eight"),
    (1, "one"),
    (2, "two"),
    (0, "zero"),
  ]
  let m3 = Map::[(3, "three"), (8, "eight"), (1, "one"), (2, "two")]
  @assertion.assert_eq(m1 == m2, true)?
  @assertion.assert_eq(m1 == m3, false)?
}
