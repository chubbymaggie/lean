-- Copyright (c) 2014 Microsoft Corporation. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Author: Leonardo de Moura
inductive unit.{l} : Type.{l} :=
  star : unit

namespace unit
  notation `⋆` := star
end unit