---
layout: post
title: JTableでファイルとディレクトリを別々にソート
category: swing
folder: FileDirectoryComparator
tags: [JTable, RowSorter, File, Comparator, DragAndDrop, UIManager, Icon, FileSystemView]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-12-13

## JTableでファイルとディレクトリを別々にソート
`JTable`でファイルとディレクトリを別々にソートし、ディレクトリが常に先頭になるように設定します。


{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQXAQuafMsI/AAAAAAAAAqU/BDQdRbMeSnE/s800/FileDirectoryComparator.png %}

### サンプルコード
<pre class="prettyprint"><code>// &gt; dir /O:GN
// &gt; ls --group-directories-first
class FileGroupComparator extends DefaultFileComparator{
  private final JTable table;
  public FileGroupComparator(JTable table, int column) {
    super(column);
    this.table = table;
  }
  @Override public int compare((File a, File b) {
    int flag = 1;
    java.util.List&lt;? extends TableRowSorter.SortKey&gt; keys
        = table.getRowSorter().getSortKeys();
    if(!keys.isEmpty()) {
      TableRowSorter.SortKey sortKey = keys.get(0);
      if(sortKey.getColumn()==column &amp;&amp;
         sortKey.getSortOrder()==SortOrder.DESCENDING) {
        flag = -1;
      }
    }
    if(a.isDirectory() &amp;&amp; !b.isDirectory()) {
      return -1*flag;
    }else if(!a.isDirectory() &amp;&amp; b.isDirectory()) {
      return  1*flag;
    }else{
      return super.compare(a, b);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JTable`に`Drag & Drop`で追加したファイルやディレクトリを、以下の`3`つのモードでソートすることが出来ます。

- `Default`
    - `File#getName()`で取得できる`String`などのデフォルトで比較
- `Directory < File`
    - 「ディレクトリ < ファイル」となるような`Comparator`を設定
- `Group Sorting`
    - 昇順の場合は「ディレクトリ < ファイル」、降順の場合は、「ディレクトリ > ファイル」として、ディレクトリが常に先頭になる`Comparator`を設定

<!-- dummy comment line for breaking list -->

### コメント
- `WindowsLookAndFeel`, `JDK 1.7.0`で`UIManager.getIcon("FileView.directoryIcon")`が取得できない？ので、`FileSystemView.getSystemIcon(...)`で`Icon`を取得するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-05-14 (月) 16:33:14

<!-- dummy comment line for breaking list -->

