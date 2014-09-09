-- category

abbreviation Prop := Type.{0}
variable eq {A : Type} : A → A → Prop
infix `=`:50 := eq

inductive category (ob : Type) (mor : ob → ob → Type) : Type :=
mk : Π (id : Π (A : ob), mor A A),
     (Π (A B : ob) (f : mor A A), id A = f) → category ob mor

abbreviation id (ob : Type) (mor : ob → ob → Type) (Cat : category ob mor) := category.rec (λ id idl, id) Cat
variable ob  : Type.{1}
variable mor : ob → ob → Type.{1}
variable Cat : category ob mor

theorem id_left (A : ob) (f : mor A A) : @eq (mor A A) (id ob mor Cat A) f :=
@category.rec ob mor (λ (C : category ob mor), @eq (mor A A) (id ob mor C A) f)
  (λ (id  : Π (T : ob), mor T T)
     (idl : Π (T : ob), _),
     idl A A f)
  Cat