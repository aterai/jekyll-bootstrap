---
layout: post
category: swing
folder: UpdateComboBoxItem
title: JComboBoxのドロップダウンリスト中にあるアイテムの状態を更新する
tags: [JComboBox, JList, JCheckBox, BasicComboPopup, DefaultComboBoxModel]
author: aterai
pubdate: 2017-06-12T17:11:53+09:00
description: JComboBoxのドロップダウンリスト中に設定されたアイテムの状態と描画を更新します。
image: https://drive.google.com/uc?id=1R3XuZTHSo7KbYggs0QI2iKVrHHBawo6f2A
comments: true
---
## 概要
`JComboBox`のドロップダウンリスト中に設定されたアイテムの状態と描画を更新します。

{% download https://drive.google.com/uc?id=1R3XuZTHSo7KbYggs0QI2iKVrHHBawo6f2A %}

## サンプルコード
<pre class="prettyprint"><code>class CheckableComboBoxModel&lt;E&gt; extends DefaultComboBoxModel&lt;E&gt; {
  protected CheckableComboBoxModel(E[] items) {
    super(items);
  }
  public void fireContentsChanged(int index) {
    super.fireContentsChanged(this, index, index);
  }
}

class CheckedComboBox4&lt;E extends CheckableItem&gt; extends CheckedComboBox&lt;E&gt; {
  protected CheckedComboBox4(ComboBoxModel&lt;E&gt; aModel) {
    super(aModel);
  }
  @Override protected void updateItem(int index) {
    if (isPopupVisible()) {
      E item = getItemAt(index);
      item.selected ^= true;
      ComboBoxModel m = getModel();
      if (m instanceof CheckableComboBoxModel) {
        ((CheckableComboBoxModel) m).fireContentsChanged(index);
      }
    }
  }
}
</code></pre>

## 解説
`JComboBox`の`BasicComboPopup`に表示されるリストは`JList`を使用しているため、マウスでクリックされたアイテムの状態を更新(上記のサンプルでは`JCheckBox`の選択状態の切替)しても、セルレンダラーでの描画は更新されません(同じアイテムがクリックされても再描画しないため)。このサンプルでは、`JComboBox`のアイテムの更新を描画に反映させるために以下のような方法をテストしています。

1. `setSelectedIndex(-1/idx)`
    - `JComboBox#setSelectedIndex(-1)`メソッドを使用して選択解除後、クリックされたアイテムを再選択することで描画を更新
    - 参考: [JComboBoxのアイテムとして表示したJCheckBoxを複数選択する](https://ateraimemo.com/Swing/CheckedComboBox.html)

<!-- dummy comment line for breaking list -->
1. `contentsChanged(...)`
    - `JComboBox#contentsChanged(ListDataEvent)`メソッドを使用して、クリックされたアイテムのみ更新しようとしているが、意図した動作にならない
    - [JComboBox#contentsChanged(ListDataEvent) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComboBox.html#contentsChanged-javax.swing.event.ListDataEvent-)

<!-- dummy comment line for breaking list -->
1. `repaint()`
    - アイテム更新後、`JComboBox`と`BasicComboPopup`から取得した`JList`の両方の`repaint()`メソッドを実行して、全体を再描画
    - 参考: [JComboBoxにAnimated GIFを表示する](https://ateraimemo.com/Swing/AnimatedIconInComboBox.html)
        - `list.repaint(list.getCellBounds(index, index));`を使用して再描画範囲を限定することも可能

<!-- dummy comment line for breaking list -->
1. `(remove/insert)ItemAt(...)`
    - `JComboBox#removeItemAt(...)`でアイテムを削除、`JComboBox#insertItemAt(...)`で状態を更新したアイテムを元の場所に挿入、`JComboBox#setSelectedIndex(...)`で挿入されたアイテムを再選択することで描画を更新

<!-- dummy comment line for breaking list -->
1. `fireContentsChanged(...)`
    - `DefaultComboBoxModel#fireContentsChanged(...)`メソッドは`protected`で直接呼び出せないため、これを呼び出し可能するラッパー`ComboBoxModel`を作成して`JComboBox`に設定し、クリックされたアイテムのみ描画を更新

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのアイテムとして表示したJCheckBoxを複数選択する](https://ateraimemo.com/Swing/CheckedComboBox.html)
- [JListのセルにJCheckBoxを使用する](https://ateraimemo.com/Swing/CheckBoxCellList.html)
    - こちらは`JList#processMouseEvent(...)`をオーバーライドして対応

<!-- dummy comment line for breaking list -->

## コメント
