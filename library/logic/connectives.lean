/-
Copyright (c) 2014 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Module: logic.connectives
Authors: Jeremy Avigad, Leonardo de Moura

The propositional connectives. See also init.datatypes and init.logic.
-/

variables {a b c d : Prop}

/- false -/

theorem false.elim {c : Prop} (H : false) : c :=
false.rec c H

/- implies -/

definition imp (a b : Prop) : Prop := a → b

theorem mt (H1 : a → b) (H2 : ¬b) : ¬a :=
assume Ha : a, absurd (H1 Ha) H2

theorem imp_true (a : Prop) : (a → true) ↔ true :=
iff.intro (assume H, trivial) (assume H H1, trivial)

theorem true_imp (a : Prop) : (true → a) ↔ a :=
iff.intro (assume H, H trivial) (assume H H1, H)

theorem imp_false (a : Prop) : (a → false) ↔ ¬ a := iff.rfl

theorem false_imp (a : Prop) : (false → a) ↔ true :=
iff.intro (assume H, trivial) (assume H H1, false.elim H1)

/- not -/

theorem not.elim (H1 : ¬a) (H2 : a) : false := H1 H2

theorem not.intro (H : a → false) : ¬a := H

theorem not_not_intro (Ha : a) : ¬¬a :=
assume Hna : ¬a, absurd Ha Hna

theorem not_not_of_not_implies (H : ¬(a → b)) : ¬¬a :=
assume Hna : ¬a, absurd (assume Ha : a, absurd Ha Hna) H

theorem not_of_not_implies (H : ¬(a → b)) : ¬b :=
assume Hb : b, absurd (assume Ha : a, Hb) H

theorem not_not_em : ¬¬(a ∨ ¬a) :=
assume not_em : ¬(a ∨ ¬a),
have Hnp : ¬a, from
  assume Hp : a, absurd (or.inl Hp) not_em,
absurd (or.inr Hnp) not_em

theorem not_true : ¬ true ↔ false :=
iff.intro (assume H, H trivial) (assume H, false.elim H)

theorem not_false_iff : ¬ false ↔ true :=
iff.intro (assume H, trivial) (assume H H1, H1)

/- and -/

definition not_and_of_not_left (b : Prop) (Hna : ¬a) : ¬(a ∧ b) :=
assume H : a ∧ b, absurd (and.elim_left H) Hna

definition not_and_of_not_right (a : Prop) {b : Prop} (Hnb : ¬b) : ¬(a ∧ b) :=
assume H : a ∧ b, absurd (and.elim_right H) Hnb

theorem and.swap (H : a ∧ b) : b ∧ a :=
and.intro (and.elim_right H) (and.elim_left H)

theorem and_of_and_of_imp_of_imp (H₁ : a ∧ b) (H₂ : a → c) (H₃ : b → d) : c ∧ d :=
and.elim H₁ (assume Ha : a, assume Hb : b, and.intro (H₂ Ha) (H₃ Hb))

theorem and_of_and_of_imp_left (H₁ : a ∧ c) (H : a → b) : b ∧ c :=
and.elim H₁ (assume Ha : a, assume Hc : c, and.intro (H Ha) Hc)

theorem and_of_and_of_imp_right (H₁ : c ∧ a) (H : a → b) : c ∧ b :=
and.elim H₁ (assume Hc : c, assume Ha : a, and.intro Hc (H Ha))

theorem and.comm : a ∧ b ↔ b ∧ a :=
iff.intro (λH, and.swap H) (λH, and.swap H)

theorem and.assoc : (a ∧ b) ∧ c ↔ a ∧ (b ∧ c) :=
iff.intro
  (assume H, and.intro
    (and.elim_left (and.elim_left H))
    (and.intro (and.elim_right (and.elim_left H)) (and.elim_right H)))
  (assume H, and.intro
    (and.intro (and.elim_left H) (and.elim_left (and.elim_right H)))
    (and.elim_right (and.elim_right H)))

theorem and_true (a : Prop) : a ∧ true ↔ a :=
iff.intro (assume H, and.left H) (assume H, and.intro H trivial)

theorem true_and (a : Prop) : true ∧ a ↔ a :=
iff.intro (assume H, and.right H) (assume H, and.intro trivial H)

theorem and_false (a : Prop) : a ∧ false ↔ false :=
iff.intro (assume H, and.right H) (assume H, false.elim H)

theorem false_and (a : Prop) : false ∧ a ↔ false :=
iff.intro (assume H, and.left H) (assume H, false.elim H)

theorem and_self (a : Prop) : a ∧ a ↔ a :=
iff.intro (assume H, and.left H) (assume H, and.intro H H)

/- or -/

definition not_or (Hna : ¬a) (Hnb : ¬b) : ¬(a ∨ b) :=
assume H : a ∨ b, or.rec_on H
  (assume Ha, absurd Ha Hna)
  (assume Hb, absurd Hb Hnb)

theorem or_of_or_of_imp_of_imp (H₁ : a ∨ b) (H₂ : a → c) (H₃ : b → d) : c ∨ d :=
or.elim H₁
  (assume Ha : a, or.inl (H₂ Ha))
  (assume Hb : b, or.inr (H₃ Hb))

theorem or_of_or_of_imp_left (H₁ : a ∨ c) (H : a → b) : b ∨ c :=
or.elim H₁
  (assume H₂ : a, or.inl (H H₂))
  (assume H₂ : c, or.inr H₂)

theorem or_of_or_of_imp_right (H₁ : c ∨ a) (H : a → b) : c ∨ b :=
or.elim H₁
  (assume H₂ : c, or.inl H₂)
  (assume H₂ : a, or.inr (H H₂))

theorem or.elim3 (H : a ∨ b ∨ c) (Ha : a → d) (Hb : b → d) (Hc : c → d) : d :=
or.elim H Ha (assume H₂, or.elim H₂ Hb Hc)

theorem or_resolve_right (H₁ : a ∨ b) (H₂ : ¬a) : b :=
or.elim H₁ (assume Ha, absurd Ha H₂) (assume Hb, Hb)

theorem or_resolve_left (H₁ : a ∨ b) (H₂ : ¬b) : a :=
or.elim H₁ (assume Ha, Ha) (assume Hb, absurd Hb H₂)

theorem or.swap (H : a ∨ b) : b ∨ a :=
or.elim H (assume Ha, or.inr Ha) (assume Hb, or.inl Hb)

theorem or.comm : a ∨ b ↔ b ∨ a :=
iff.intro (λH, or.swap H) (λH, or.swap H)

theorem or.assoc : (a ∨ b) ∨ c ↔ a ∨ (b ∨ c) :=
iff.intro
  (assume H, or.elim H
    (assume H₁, or.elim H₁
      (assume Ha, or.inl Ha)
      (assume Hb, or.inr (or.inl Hb)))
    (assume Hc, or.inr (or.inr Hc)))
  (assume H, or.elim H
    (assume Ha, (or.inl (or.inl Ha)))
    (assume H₁, or.elim H₁
      (assume Hb, or.inl (or.inr Hb))
      (assume Hc, or.inr Hc)))

theorem or_true (a : Prop) : a ∨ true ↔ true :=
iff.intro (assume H, trivial) (assume H, or.inr H)

theorem true_or (a : Prop) : true ∨ a ↔ true :=
iff.intro (assume H, trivial) (assume H, or.inl H)

theorem or_false (a : Prop) : a ∨ false ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1 : a, H1) (assume H1 : false, false.elim H1))
  (assume H, or.inl H)

theorem false_or (a : Prop) : false ∨ a ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1 : false, false.elim H1) (assume H1 : a, H1))
  (assume H, or.inr H)

theorem or_self (a : Prop) : a ∨ a ↔ a :=
iff.intro
  (assume H, or.elim H (assume H1, H1) (assume H1, H1))
  (assume H, or.inl H)

/- iff -/

definition iff.def : (a ↔ b) = ((a → b) ∧ (b → a)) :=
!eq.refl

theorem iff_true (a : Prop) : (a ↔ true) ↔ a :=
iff.intro
  (assume H, iff.mp' H trivial)
  (assume H, iff.intro (assume H1, trivial) (assume H1, H))

theorem true_iff (a : Prop) : (true ↔ a) ↔ a :=
iff.intro
  (assume H, iff.mp H trivial)
  (assume H, iff.intro (assume H1, H) (assume H1, trivial))

theorem iff_false (a : Prop) : (a ↔ false) ↔ ¬ a :=
iff.intro
  (assume H, and.left H)
  (assume H, and.intro H (assume H1, false.elim H1))

theorem false_iff (a : Prop) : (false ↔ a) ↔ ¬ a :=
iff.intro
  (assume H, and.right H)
  (assume H, and.intro (assume H1, false.elim H1) H)

theorem iff_true_of_self (Ha : a) : a ↔ true :=
iff.intro (assume H, trivial) (assume H, Ha)

theorem iff_self (a : Prop) : (a ↔ a) ↔ true :=
iff_true_of_self !iff.refl

/- if-then-else -/

section
  open eq.ops

  variables {A : Type} {c₁ c₂ : Prop}

  definition if_true (t e : A) : (if true then t else e) = t :=
  if_pos trivial

  definition if_false (t e : A) : (if false then t else e) = e :=
  if_neg not_false

  theorem if_congr_cond [H₁ : decidable c₁] [H₂ : decidable c₂] (Heq : c₁ ↔ c₂) (t e : A) :
    (if c₁ then t else e) = (if c₂ then t else e) :=
  decidable.rec_on H₁
   (λ Hc₁  : c₁,  decidable.rec_on H₂
     (λ Hc₂  : c₂,  if_pos Hc₁ ⬝ (if_pos Hc₂)⁻¹)
     (λ Hnc₂ : ¬c₂, absurd (iff.elim_left Heq Hc₁) Hnc₂))
   (λ Hnc₁ : ¬c₁, decidable.rec_on H₂
     (λ Hc₂  : c₂,  absurd (iff.elim_right Heq Hc₂) Hnc₁)
     (λ Hnc₂ : ¬c₂, if_neg Hnc₁ ⬝ (if_neg Hnc₂)⁻¹))

  theorem if_congr_aux [H₁ : decidable c₁] [H₂ : decidable c₂] {t₁ t₂ e₁ e₂ : A}
      (Hc : c₁ ↔ c₂) (Ht : t₁ = t₂) (He : e₁ = e₂) :
    (if c₁ then t₁ else e₁) = (if c₂ then t₂ else e₂) :=
  Ht ▸ He ▸ (if_congr_cond Hc t₁ e₁)

  theorem if_congr [H₁ : decidable c₁] {t₁ t₂ e₁ e₂ : A} (Hc : c₁ ↔ c₂) (Ht : t₁ = t₂)
      (He : e₁ = e₂) :
    (if c₁ then t₁ else e₁) = (@ite c₂ (decidable_of_decidable_of_iff H₁ Hc) A t₂ e₂) :=
  assert H2 : decidable c₂, from (decidable_of_decidable_of_iff H₁ Hc),
  if_congr_aux Hc Ht He
end
