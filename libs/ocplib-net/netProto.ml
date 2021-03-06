(**************************************************************************)
(*                                                                        *)
(*    Copyright 2017-2018 OCamlPro                                        *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

open StringCompat

module type S = sig
  type chars
  val get_uint8 : chars -> int -> int * int
  val get_uint16 : chars -> int -> int * int

  val get_int16 : chars -> int -> int * int

  val get_int31 : chars -> int -> int * int
  val get_int32 : chars -> int -> int32 * int

  val get_string8 : chars -> int -> string * int
  val get_string16 : chars -> int -> string * int
  val get_string31 : chars -> int -> string * int

end

module Endian = EndianBytes.LittleEndian

  let buf_int8 b n =
    Buffer.add_char b (char_of_int n)

  let buf_int16 b n =
    let bb = Bytes.create 2 in
    Endian.set_int16 bb 0 n;
    Buffer.add_bytes b bb

  let buf_int32 b n =
    let bb = Bytes.create 4 in
    Endian.set_int32 bb 0 n;
    Buffer.add_bytes b bb

  let buf_int31 b n =
    buf_int32 b (Int32.of_int n)

  let buf_string31 b s =
    buf_int31 b (String.length s);
    Buffer.add_string b s

  let buf_string8 b s =
    buf_int8 b (String.length s);
    Buffer.add_string b s

  let buf_string16 b s =
    buf_int16 b (String.length s);
    Buffer.add_string b s

  let set_int32 s pos n =
    Endian.set_int32 s pos n

  let set_int31 s pos n =
    set_int32 s pos (Int32.of_int n)


module Bytes : S with type chars := bytes
                                    = struct

  let get_uint8 s pos =
    int_of_char (Bytes.get s pos), pos+1

  let get_uint16 s pos =
    Endian.get_uint16 s pos, pos + 2

  let get_int16 s pos =
    Endian.get_uint16 s pos, pos + 2

  let get_int32 s pos =
    Endian.get_int32 s pos, pos + 4

  let get_int31 s pos =
    let n,pos = get_int32 s pos in
    Int32.to_int n, pos

  let get_string8 s pos =
    let len, pos = get_uint8 s pos in
    Bytes.sub_string s pos len, pos + len

  let get_string16 s pos =
    let len, pos = get_uint16 s pos in
    Bytes.sub_string s pos len, pos + len

  let get_string31 s pos =
    let len, pos = get_int31 s pos in
    Bytes.sub_string s pos len, pos + len

                      end
;;

module String :
  S with type chars := string
  = struct

           module Endian = EndianString.LittleEndian

  let get_uint8 s pos =
    int_of_char s.[pos], pos+1

  let get_uint16 s pos =
    Endian.get_uint16 s pos, pos + 2

  let get_int16 s pos =
    Endian.get_uint16 s pos, pos + 2

  let get_int32 s pos =
    Endian.get_int32 s pos, pos + 4

  let get_int31 s pos =
    let n,pos = get_int32 s pos in
    Int32.to_int n, pos

  let get_string8 s pos =
    let len, pos = get_uint8 s pos in
    String.sub s pos len, pos + len

  let get_string16 s pos =
    let len, pos = get_uint16 s pos in
    String.sub s pos len, pos + len

  let get_string31 s pos =
    let len, pos = get_int31 s pos in
    String.sub s pos len, pos + len

  end
;;
