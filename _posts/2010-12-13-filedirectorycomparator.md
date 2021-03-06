---
layout: post
category: swing
folder: FileDirectoryComparator
title: JTableでファイルとディレクトリを別々にソート
tags: [JTable, RowSorter, File, Comparator, DragAndDrop, UIManager, Icon, FileSystemView]
author: aterai
pubdate: 2010-12-13T15:54:21+09:00
description: JTableでファイルとディレクトリを別々にソートし、ディレクトリが常に先頭になるように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQXAQuafMsI/AAAAAAAAAqU/BDQdRbMeSnE/s800/FileDirectoryComparator.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/11/jtable-group-directories-first-sorting.html
    lang: en
comments: true
---
## 概要
`JTable`でファイルとディレクトリを別々にソートし、ディレクトリが常に先頭になるように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQXAQuafMsI/AAAAAAAAAqU/BDQdRbMeSnE/s800/FileDirectoryComparator.png %}

## サンプルコード
<pre class="prettyprint"><code>// &gt; dir /O:GN
// &gt; ls --group-directories-first
class FileGroupComparator extends DefaultFileComparator {
  private static final long serialVersionUID = 1L;
  private final JTable table;
  public FileGroupComparator(JTable table, int column) {
    super(column);
    this.table = table;
  }
  @Override public int compare(File a, File b) {
    int flag = 1;
    List&lt;? extends TableRowSorter.SortKey&gt; keys = table.getRowSorter().getSortKeys();
    if (!keys.isEmpty()) {
      TableRowSorter.SortKey sortKey = keys.get(0);
      if (sortKey.getColumn() == column &amp;&amp;
          sortKey.getSortOrder() == SortOrder.DESCENDING) {
        flag = -1;
      }
    }
    if (a.isDirectory() &amp;&amp; !b.isDirectory()) {
      return -1 * flag;
    } else if (!a.isDirectory() &amp;&amp; b.isDirectory()) {
      return 1 * flag;
    } else {
      return super.compare(a, b);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`にドラッグ＆ドロップで追加したファイルやディレクトリを以下の`3`種類の`Comparator`でソートが可能です。

- `Default`
    - `File#getName()`で取得したファイル名`String`で比較
- `Directory < File`
    - ファイル名より先に「ディレクトリ < ファイル」で比較する`Comparator`を設定
- `Group Sorting`
    - 昇順の場合は「ディレクトリ < ファイル」、降順の場合は、「ディレクトリ > ファイル」として、常にディレクトリが優先される`Comparator`を設定
    - ディレクトリ同士、ファイル同士の場合は、ファイル名で比較する
    - `ls`コマンドの`--group-directories-first`オプションを付けた状態と同じソート

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのソート](https://ateraimemo.com/Swing/SortTree.html)
- [JTableで同一内容のセルを空表示にしてグループ化を表現する](https://ateraimemo.com/Swing/RowGroupInTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- `WindowsLookAndFeel`, `JDK 1.7.0`で`UIManager.getIcon("FileView.directoryIcon")`が取得できない？ので、`FileSystemView.getSystemIcon(...)`で`Icon`を取得するように変更。 -- *aterai* 2012-05-14 (月) 16:33:14

<!-- dummy comment line for breaking list -->
