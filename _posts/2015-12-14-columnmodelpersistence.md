---
layout: post
category: swing
folder: ColumnModelPersistence
title: TableColumnModelをXMLファイルで保存、復元する
tags: [JTable, JTableHeader, TableColumnModel, XMLEncoder, XMLDecoder]
author: aterai
pubdate: 2015-12-14T02:58:18+09:00
description: JTableのヘッダからTableColumnModelを取得し、XMLEncoderとXMLDecoderを使って、XMLファイルで保存、復元します。
image: https://lh3.googleusercontent.com/-3ZhmTqRFkgU/Vm2uUZ4_gCI/AAAAAAAAOI4/bY9IRX-guT4/s800-Ic42/ColumnModelPersistence.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2016/01/save-and-load-state-of-jtable-and.html
    lang: en
comments: true
---
## 概要
`JTable`のヘッダから`TableColumnModel`を取得し、`XMLEncoder`と`XMLDecoder`を使って、`XML`ファイルで保存、復元します。

{% download https://lh3.googleusercontent.com/-3ZhmTqRFkgU/Vm2uUZ4_gCI/AAAAAAAAOI4/bY9IRX-guT4/s800-Ic42/ColumnModelPersistence.png %}

## サンプルコード
<pre class="prettyprint"><code>class TableColumnModelPersistenceDelegate extends DefaultPersistenceDelegate {
  @Override protected void initialize(
      Class&lt;?&gt; type, Object oldInstance, Object newInstance, Encoder encoder) {
    super.initialize(type, oldInstance, newInstance, encoder);
    DefaultTableColumnModel m = (DefaultTableColumnModel) oldInstance;
    for (int col = 0; col &lt; m.getColumnCount(); col++) {
      Object[] o = {m.getColumn(col)};
      encoder.writeStatement(new Statement(oldInstance, "addColumn", o));
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTableHeader`から`TableColumnModel`を取得し、`XMLEncoder`で`XML`ファイルに保存、`XMLDecoder`で復元することで、マウスドラッグによる列の入れ替え、幅の変更、カラム名の変更などを永続化できます。

## 参考リンク
- [JTableのモデルをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/PersistenceDelegate.html)
- [JTableのSortKeyを永続化し、ソート状態の保存と復元を行う](https://ateraimemo.com/Swing/SortKeyPersistence.html)
- [JTableのColumn名を変更する](https://ateraimemo.com/Swing/EditColumnName.html)

<!-- dummy comment line for breaking list -->

## コメント
