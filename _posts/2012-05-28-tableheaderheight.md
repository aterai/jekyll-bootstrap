---
layout: post
title: JTableHeaderの高さを変更
category: swing
folder: TableHeaderHeight
tags: [JTableHeader, JTable, JScrollPane, JViewport]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-05-28

## JTableHeaderの高さを変更
`JTableHeader`の高さを変更します。

{% download https://lh4.googleusercontent.com/-l20IOO5wKSo/T8MIf7FVUwI/AAAAAAAABNM/9BNN63T96Fo/s800/TableHeaderHeight.png %}

### サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(table);
scroll.setColumnHeader(new JViewport() {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.height = 32;
    return d;
  }
});
</code></pre>

### 解説
- 上
    - `JTableHeader`に`null`(デフォルト)以外のサイズを`setPreferredSize(...)`で設定
    - `JTable.AUTO_RESIZE_OFF`の場合、設定されたこのサイズが列の追加や列幅の変更で更新されない(仕様？)ため、ヘッダの描画が不正になる
        - [JTableのJTalbeHeaderの高さを変更して列幅の合計が１２００ピクセルを超えて横スクロールするとバグった。 - kensir0uのしくみ](http://d.hatena.ne.jp/kensir0u/20090416/1239898154)
    - `JTable.AUTO_RESIZE_OFF`以外の場合は、`setPreferredSize(...)`で設定された幅は無視されて、`JTable`の幅が使用される

<!-- dummy comment line for breaking list -->

- 下
    - `JViewport#getPreferredSize()`もしくは、`JTableHeader#getPreferredSize()`をオーバーライドして、`JTableHeader`の高さを変更
        
        <pre class="prettyprint"><code>table.setTableHeader(new JTableHeader(table.getColumnModel()) {
          @Override public Dimension getPreferredSize() {
            Dimension d = super.getPreferredSize();
            d.height = 32;
            return d;
          }
        });
</code></pre>
    - `viewport.setPreferredSize(...)`と設定しても可…?
    - `JTableHeader#getHeight()`をオーバーライドすると、ヘッダ文字列などの描画だけ(`getHeight()`は`JTableHeader#getHeaderRect()`で使用されている)変更される

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableのJTalbeHeaderの高さを変更して列幅の合計が１２００ピクセルを超えて横スクロールするとバグった。 - kensir0uのしくみ](http://d.hatena.ne.jp/kensir0u/20090416/1239898154)
    - このバグ？の状態を適切に示す良いサンプルコードがあります。

<!-- dummy comment line for breaking list -->

### コメント
