---
layout: post
category: swing
folder: SortKeyPersistence
title: JTableのSortKeyを永続化し、ソート状態の保存と復元を行う
tags: [JTable, RowSorter, XMLDecoder, XMLEncoder]
author: aterai
pubdate: 2015-09-21T01:26:03+09:00
description: JTableのSortKeyを永続化して、そのソート状態をXMLファイルで保存、復元できるように設定します。
image: https://lh3.googleusercontent.com/-x9GESOvXeyc/Vf7c-CY1veI/AAAAAAAAOCE/lUO7hcq8-fw/s800-Ic42/SortKeyPersistence.png
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
    - `TableModel`の書出しには、別途[JTableのモデルをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/PersistenceDelegate.html)を使用
    - このサンプルでは、カラムヘッダの幅や順序には対応していない
        - メモ: [JTable Inhalte speichern – Byte-Welt Wiki](http://wiki.byte-welt.net/wiki/JTable_Inhalte_speichern)
        - または、[TableColumnModelをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/ColumnModelPersistence.html)のような`DefaultPersistenceDelegate`を使ってカラムヘッダの幅や順序を保存する方法がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのモデルをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/PersistenceDelegate.html)
- [TableColumnModelをXMLファイルで保存、復元する](https://ateraimemo.com/Swing/ColumnModelPersistence.html)

<!-- dummy comment line for breaking list -->

## コメント
- 大変勉強になります。`JTable`の列入替え(`Drag&Drop`操作による)の状態も保存することは可能なのでしょうか？ -- *hirohiro* 2015-11-11 (水) 17:57:58
    - @hirohiro さん、こんばんは。`JTable`の列入替えの状態を保存する場合、`DefaultTableColumnModel`用の`DefaultPersistenceDelegate`を作成してヘッダカラムの幅や順序を保存する方法があります(記事の解説も追加・修正しました)。 -- *aterai* 2015-11-13 (金) 17:57:58
    - サンプルコード: [DefaultTableColumnModelPersistenceDelegateTest.java](https://gist.github.com/aterai/c9b8d33d04f848d552fa)
    - 他にも、[JTable Inhalte speichern – Byte-Welt Wiki](http://wiki.byte-welt.net/wiki/JTable_Inhalte_speichern)のように`getter`や`setter`を`DefaultTableColumnModel`に追加して`XMLEncoder/XMLDecoder`する方法もあるようです。

<!-- dummy comment line for breaking list -->
