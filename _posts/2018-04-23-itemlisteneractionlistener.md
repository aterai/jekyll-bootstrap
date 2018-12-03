---
layout: post
category: swing
folder: ItemListenerActionListener
title: ItemListenerとActionListenerの動作の違いを比較する
tags: [ItemListener, ActionListener, JComboBox, JCheckBox, JRadioButton, ButtonGroup]
author: aterai
pubdate: 2018-04-23T18:28:12+09:00
description: JComboBoxやJCheckBoxなどに設定したItemListenerとActionListenerの動作を比較テストします。
image: https://drive.google.com/uc?id=1xpBmSl-frNjI1eCiUe2pzY2vo6Zp_FpKjA
comments: true
---
## 概要
`JComboBox`や`JCheckBox`などに設定した`ItemListener`と`ActionListener`の動作を比較テストします。

{% download https://drive.google.com/uc?id=1xpBmSl-frNjI1eCiUe2pzY2vo6Zp_FpKjA %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;DayOfWeek&gt; combo = new JComboBox&lt;&gt;(DayOfWeek.values());
combo.addItemListener(e -&gt; {
  ItemSelectable c = e.getItemSelectable();
  DayOfWeek dow = (DayOfWeek) e.getItem();
  boolean b = e.getStateChange() == ItemEvent.SELECTED;
  print(textArea, "ItemListener", c.getClass(), b, dow);
});
combo.addActionListener(e -&gt; {
  Object c = e.getSource();
  DayOfWeek dow = combo.getItemAt(combo.getSelectedIndex());
  boolean b = Objects.equals("comboBoxChanged", e.getActionCommand());
  print(textArea, "ActionListener", c.getClass(), b, dow);
});
</code></pre>

## 解説
`JComboBox`

- `ItemListener`
    - `ItemEvent#getItemSelectable()`でイベント元の`JComboBox`が取得可能
    - `ItemEvent#getItem()`で`JComboBox`で選択されたアイテムが取得可能
    - `ItemEvent#getStateChange()`で`JComboBox`のアイテムが選択、選択解除されたかを取得可能
    - `JComboBox#setSelectedIndex(...)`メソッドなどを使用して`JComboBox`を直接マウスやキー入力で操作しなくても、`ItemEvent`は発生する
    - `JComboBox`の同じアイテムを選択しても`ItemEvent`は発生しない
- `ActionListener`
    - `ActionEvent#getSource()`でイベント元の`JComboBox`が取得可能
    - デフォルトの`JComboBox`は、`ActionEvent#getActionCommand()`で`"comboBoxChanged"`を返す
    - `JComboBox#setSelectedIndex(...)`メソッドなどを使用して`JComboBox`を直接マウスやキー入力で操作しなくても、`ActionEvent`は発生する
    - `JComboBox`の同じアイテムを選択しても`ActionEvent`は発生する

<!-- dummy comment line for breaking list -->

`JCheckBox`

- `ItemListener`
    - `ItemEvent#getItemSelectable()`、または`ItemEvent#getItem()`でイベント元の`JCheckBox`が取得可能
    - `ItemEvent#getStateChange()`で`JCheckBox`が選択されたかを取得可能
    - `JCheckBox#setSelected(...)`メソッドなどを使用して`JCheckBox`を直接マウスやキー入力で操作しなくても、`ItemEvent`は発生する
    - `JCheckBox#setSelected(...)`メソッドを使用しても選択状態が変化しない場合、`ItemEvent`は発生しない
- `ActionListener`
    - `ActionEvent#getSource()`でイベント元の`JCheckBox`が取得可能
    - デフォルトの`JCheckBox`は、`ActionEvent#getActionCommand()`で`JCheckBox#getText()`と同じ値を返す
    - `JCheckBox#setSelected(...)`メソッドなどを使用して`JCheckBox`の状態を変更しても、`ActionEvent`は発生しない

<!-- dummy comment line for breaking list -->

`JRadioButton`(`ButtonGroup`)

- `ItemListener`
    - `ItemEvent#getItemSelectable()`、または`ItemEvent#getItem()`でイベント元の`JCheckBox`が取得可能
    - `ItemEvent#getStateChange()`で`JRadioButton`が選択されたかを取得可能
    - `JRadioButton#setSelected(...)`メソッドなどを使用して`JRadioButton`を直接マウスやキー入力で操作しなくても、`ItemEvent`は発生する
    - `JRadioButton#setSelected(...)`メソッドを使用しても選択状態が変化しない場合、`ItemEvent`は発生しない
    - 注: `ButtonGroup#getSelection()`は、`JRadioButton#setSelected(...)`メソッドを使用して選択変更した場合は`null`、マウスなどで選択変更した場合はその`ButtonModel`を返す
- `ActionListener`
    - `ActionEvent#getSource()`でイベント元の`JRadioButton`が取得可能
    - デフォルトの`JRadioButton`は、`ActionEvent#getActionCommand()`で`JRadioButton#getText()`と同じ値を返す
    - `JRadioButton#setSelected(...)`メソッドなどを使用して`JRadioButton`の状態を変更しても、`ActionEvent`は発生しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JCheckbox - ActionListener and ItemListener? - Stack Overflow](https://stackoverflow.com/questions/9882845/jcheckbox-actionlistener-and-itemlistener)

<!-- dummy comment line for breaking list -->

## コメント
