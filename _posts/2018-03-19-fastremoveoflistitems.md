---
layout: post
category: swing
folder: FastRemoveOfListItems
title: JListからの大量アイテム削除を高速化する
tags: [JList, ListModel, AbstractListModel, DefaultListModel, SpringLayout]
author: aterai
pubdate: 2018-03-19T16:16:24+09:00
description: JListのListModelからの大量のアイテムを高速に削除する方法をテストします。
image: https://drive.google.com/uc?id=1w4uURJH6pPCGk68BT_XlCjxnZQlOxv1n7w
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/04/move-large-numbers-of-items-to-another.html
    lang: en
comments: true
---
## 概要
`JList`の`ListModel`からの大量のアイテムを高速に削除する方法をテストします。

{% download https://drive.google.com/uc?id=1w4uURJH6pPCGk68BT_XlCjxnZQlOxv1n7w %}

## サンプルコード
<pre class="prettyprint"><code>private static &lt;E&gt; void move1(JList&lt;E&gt; from, JList&lt;E&gt; to) {
  ListSelectionModel sm = from.getSelectionModel();
  int[] selectedIndices = from.getSelectedIndices();

  DefaultListModel&lt;E&gt; fromModel = (DefaultListModel&lt;E&gt;) from.getModel();
  DefaultListModel&lt;E&gt; toModel = (DefaultListModel&lt;E&gt;) to.getModel();
  List&lt;E&gt; unselectedValues = new ArrayList&lt;&gt;();
  for (int i = 0; i &lt; fromModel.getSize(); i++) {
    if (!sm.isSelectedIndex(i)) {
      unselectedValues.add(fromModel.getElementAt(i));
    }
  }
  if (selectedIndices.length &gt; 0) {
    for (int i: selectedIndices) {
      toModel.addElement(fromModel.get(i));
    }
    fromModel.clear();
    // unselectedValues.forEach(fromModel::addElement);
    DefaultListModel&lt;E&gt; model = new DefaultListModel&lt;&gt;();
    unselectedValues.forEach(model::addElement);
    from.setModel(model);
  }
}
</code></pre>

## 解説
上記のサンプルでは、大量のアイテムをもつ`JList`を左右に配置し、選択アイテムを`>`、`<`ボタンで移動するテストを行っています。

- `default remove`(`5000`件)
    - 移動元の`JList`で選択されているアイテムのインデックスを`JList#getSelectedIndices()`メソッドで取得
    - このインデックス配列を`for`文でループして移動元の`DefaultListModel`から`get(idx)`でアイテムを取得し、これを移動先の`DefaultListModel`へ`addElement(...)`メソッドでコピー
    - このインデックス配列を`for`文で末尾からループし、移動元の`DefaultListModel`から`remove(idx)`でアイテムを削除
    - `DefaultListModel#remove(idx)`内で実行される`AbstractListModel#fireIntervalRemoved(...)`が遅いため、アイテムを大量に削除する場合非常に時間が掛かる
    - `DefaultListModel#removeAllElements()`で全削除、`JList`の選択モードが`ListSelectionModel.MULTIPLE_INTERVAL_SELECTION`で`DefaultListModel#removeRange(...)`メソッドで範囲削除が可能な場合、`AbstractListModel#fireIntervalRemoved(...)`は最後に一回呼ばれるだけなので高速
- `clear + addElement`(`20000`件)
    - 移動元の`JList`で選択されていないアイテムを別の`ArrayList`に保存
    - 移動元の`JList`の選択インデックス配列を`for`ループで回して、移動元の`DefaultListModel`へ`addElement(...)`でコピー
    - `DefaultListModel#clear()`で移動元の`JList`をクリア
    - 保存していた未選択アイテムリストから移動元の`JList`にアイテムを復元
    - `AbstractListModel#fireIntervalRemoved(...)`は`DefaultListModel#clear()`で一回呼ばれるだけなので高速
    - リストの先頭の`1`件を選択して移動すると時間がかかる
        - 先頭を含まない場合は高速
        - `DefaultListModel`を新規生成して入れ替えれば高速
- `addAll + remove`(`20000`件)
    - `AbstractListModel`を継承するリストモデルを作成
    - `DefaultListModel`で使用している`Vector`ではなく、`ArrayList`をアイテムの保持に使用
    - 選択アイテムのインデックス配列を引数にしてまとめて削除を実行するメソッドを追加
        - `AbstractListModel#fireIntervalRemoved(...)`は最後に一回呼ばれるだけなので高速
            
            <pre class="prettyprint"><code>public void remove(int... selectedIndices) {
              if (selectedIndices.length &gt; 0) {
                int max = selectedIndices.length - 1;
                for (int i = max; i &gt;= 0; i--) {
                  delegate.remove(selectedIndices[i]);
                }
                fireIntervalRemoved(this, selectedIndices[0], selectedIndices[max]);
              }
            }
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `JTable`でも大量の行を高速に削除する場合は、同様の方法を取る必要がある
    
    <pre class="prettyprint"><code>List&lt;Vector&gt; unselectedRows = new ArrayList&lt;&gt;(model.getRowCount());
    ListSelectionModel sm = table.getSelectionModel();
    for (int i = 0; i &lt; model.getRowCount(); i++) {
      if (!sm.isSelectedIndex(i)) {
        int idx = table.convertRowIndexToModel(i);
        unselectedRows.add((Vector) model.getDataVector().get(idx));
      }
    }
    model.setRowCount(0);
    unselectedRows.forEach(model::addRow);
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- 左右の`JList`、中央の`JButton`の配置は、`SpringLayout`を使用してレイアウト
    - [SpringLayoutの使用](https://ateraimemo.com/Swing/SpringLayout.html)
    - 左右の`JList`: 親パネルの幅の`40%`
    - 中央の`JButton`を縦に配置した`Box.createVerticalBox()`: 親パネルの幅の`10%`
        - 中央の幅を固定にする場合は、[Componentの3列配置、中央幅固定、左右均等引き伸ばしを行うLayoutManagerを作成する](https://ateraimemo.com/Swing/ThreeColumnLayout.html)のような方法がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultListModel (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultListModel.html)
- [AbstractListModel (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/AbstractListModel.html)

<!-- dummy comment line for breaking list -->

## コメント
