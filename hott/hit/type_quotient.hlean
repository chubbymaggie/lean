/-
Copyright (c) 2015 Floris van Doorn. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Module: hit.type_quotient
Authors: Floris van Doorn

Type quotients (quotient without truncation)
-/

/- The hit type_quotient is primitive, declared in init.hit. -/

open eq equiv sigma.ops

namespace type_quotient

  variables {A : Type} {R : A → A → Type}

  protected definition elim {P : Type} (Pc : A → P) (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a = Pc a')
    (x : type_quotient R) : P :=
  type_quotient.rec Pc (λa a' H, !tr_constant ⬝ Pp H) x

  protected definition elim_on [reducible] {P : Type} (x : type_quotient R)
    (Pc : A → P) (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a = Pc a') : P :=
  elim Pc Pp x

  protected definition elim_eq_of_rel {P : Type} (Pc : A → P)
    (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a = Pc a') {a a' : A} (H : R a a')
    : ap (elim Pc Pp) (eq_of_rel H) = Pp H :=
  sorry

  protected definition elim_type (Pc : A → Type)
    (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a ≃ Pc a') : type_quotient R → Type :=
  elim Pc (λa a' H, ua (Pp H))

  protected definition elim_type_on [reducible] (x : type_quotient R) (Pc : A → Type)
    (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a ≃ Pc a') : Type :=
  elim_type Pc Pp x

  protected definition elim_type_eq_of_rel (Pc : A → Type)
    (Pp : Π⦃a a' : A⦄ (H : R a a'), Pc a ≃ Pc a') {a a' : A} (H : R a a')
    : transport (elim_type Pc Pp) (eq_of_rel H) = to_fun (Pp H) :=
  sorry

  definition elim_type_uncurried (H : Σ(Pc : A → Type),  Π⦃a a' : A⦄ (H : R a a'), Pc a ≃ Pc a')
    : type_quotient R → Type :=
  elim_type H.1 H.2

end type_quotient
