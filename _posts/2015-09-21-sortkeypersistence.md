---
layout: post
category: swing
folder: SortKeyPersistence
title: JTableのSortKeyを永続化し、ソート状態の保存と復元を行う
tags: [JTable, RowSorter, XMLDecoder, XMLEncoder]
author: aterai
pubdate: 2015-09-21T01:26:03+09:00
description: JTableのSortKeyを永続化して、そのソート状態をXMLファイルで保存、復元できるように設定します。
comments: true
---
## 概要
`JTable`の`SortKey`を永続化して、そのソート状態を`XML`ファイルで保存、復元できるように設定します。

{% download https://lh3.googleusercontent.com/-x9GESOvXeyc/Vf7c-CY1veI/AAAAAAAAOCE/lUO7hcq8-fw/s800-Ic42/SortKeyPersistence.png %}

## サンプルコード
<pre class="prettyprint"><code>File file = File.createTempFile("output", ".xml");
try (XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(file)))) {
  xe.setPersistenceDelegate(
    RowSorter.SortKey.class,
    new DefaultPersistenceDelegate(new String[] {"column", "sortOrder"}));
  xe.writeObject(table.getRowSorter().getSortKeys());
//...
</code></pre>

## 解説
上記のサンプルでは、`JTable`のソート状態を表す`RowSorter.SortKey`を永続化するため、以下のような設定を行っています。

- `RowSorter.SortKey`クラスのコンストラクタの引数をプロパティ名として`DefaultPersistenceDelegate`を作成
- `RowSorter.SortKey`クラスを`XML`で書き出すため、`XMLEncoder#setPersistenceDelegate(...)`で上記の`PersistenceDelegate`を設定

<!-- dummy comment line for breaking list -->

- 注:
    - `TableModel`は、別途、[JTableのモデルをXMLファイルで保存、復元する](http://ateraimemo.com/Swing/PersistenceDelegate.html)を使用
    - このサンプルでは、ヘッダカラムの幅や順序には対応していない
        - メモ: [JTable Inhalte speichern – Byte-Welt Wiki](http://wiki.byte-welt.net/wiki/JTable_Inhalte_speichern)
        - または、[TableColumnModelをXMLファイルで保存、復元する](http://ateraimemo.com/Swing/ColumnModelPersistence.html)のような`DefaultPersistenceDelegate`を使ってヘッダカラムの幅や順序を保存する方法がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのモデルをXMLファイルで保存、復元する](http://ateraimemo.com/Swing/PersistenceDelegate.html)
- [TableColumnModelをXMLファイルで保存、復元する](http://ateraimemo.com/Swing/ColumnModelPersistence.html)

<!-- dummy comment line for breaking list -->

## コメント
