---
layout: post
category: swing
folder: SortedListModel
title: JListのモデルをソートする
tags: [JList, ListModel]
author: aterai
pubdate: 2020-06-08T16:59:00+09:00
description: JListのモデルに追加したアイテムの名前などを条件として昇順・降順ソートを実行します。
image: https://drive.google.com/uc?id=1mT1M-6FPOizXbOEh4iADApE765Hu2jf2
comments: true
---
## 概要
`JList`のモデルに追加したアイテムの名前などを条件として昇順・降順ソートを実行します。

{% download https://drive.google.com/uc?id=1mT1M-6FPOizXbOEh4iADApE765Hu2jf2 %}

## サンプルコード
<pre class="prettyprint"><code>comparator = Comparator.comparing(ListItem::getTitle);
if (descending.isSelected()) {
  comparator = comparator.reversed();
}
List&lt;ListItem&gt; selected = list.getSelectedValuesList();
model.clear();
if (comparator == null) {
  Stream.of(defaultModel).forEach(model::addElement);
  directionList.forEach(r -&gt; r.setEnabled(false));
} else {
  Stream.of(defaultModel).sorted(comparator).forEach(model::addElement);
  directionList.forEach(r -&gt; r.setEnabled(true));
}
for (ListItem item : selected) {
  int i = model.indexOf(item);
  list.addSelectionInterval(i, i);
}
</code></pre>

## 解説
- [水平ニュースペーパー・スタイルレイアウト](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#HORIZONTAL_WRAP)を設定した`JList`で、アイテム(セル)のタイトル文字列やアイコンのカラーコードでソートを実行
    - `JRadioButton`が選択されると`Comparator<ListItem>`を変更して元リストモデルのストリームから`Stream#sorted(comparator)`を実行してソートされた新規リストモデルを作成している
    - `JList`デフォルトのセルを垂直方向に`1`列に並べたレイアウトで一種類のソートを行う場合は、ヘッダを非表示にした`JTable`と`RowFilter`で代用可能
- `Sort`
    - `None`
        - アイテムの初期配列(`ListItem[]`)からソートなしでリストモデルを復元
    - `Name`
        - `Comparator.comparing(ListItem::getTitle)`でソートしたリストモデルを`JList`に設定
    - `Color`
        - `Comparator.comparing(item -> item.getColor().getRGB())`でソートしたリストモデルを`JList`に設定
- `Direction`
    - `ascending`
        - 昇順になる`Comparator`を使用
    - `descending`
        - 降順になるよう`Comparator#.reversed()`を使用して`Comparator`を変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのソート](https://ateraimemo.com/Swing/SortTree.html)
- [JListのアイテムをフィルタリングして表示](https://ateraimemo.com/Swing/FilterListItems.html)

<!-- dummy comment line for breaking list -->

## コメント
