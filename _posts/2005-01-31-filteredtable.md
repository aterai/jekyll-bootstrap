---
layout: post
title: JTableに行フィルタで表示の切り替え
category: swing
folder: FilteredTable
tags: [JTable, DefaultTableModel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-01-31

## JTableに行フィルタで表示の切り替え
`JTable`に表示する行をフィルタを使用して切り替えます。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTMpQqDR4I/AAAAAAAAAZg/vitkhyUoKkI/s800/FilteredTable.png)

### サンプルコード
<pre class="prettyprint"><code>class TestModel extends DefaultTableModel {
  public static final String NUMBER  = "番号";
  public static final String MASTER  = "名前";
  public static final String COMMENT = "コメント";
  private final Vector list = new Vector();
  public TestModel() {
    super(new String[]{NUMBER, MASTER, COMMENT}, 0);
  }
  public void addRow(Test tst) {
    list.add(tst);
    Integer num = new Integer(list.size());
    Object[] obj = {num, tst.getName(), tst.getComment()};
    addRow(obj);
  }
  public void filterRows(boolean flg) {
    //Vector v = new Vector(list.size());
    dataVector.clear();
    for(int i=0;i&lt;list.size();i++) {
      //if(flg &amp;&amp; i%2!=0) continue;
      if(flg &amp;&amp; i%2==0) continue;
      Test t = (Test)list.elementAt(i);
      Object[] o = {Integer.valueOf(i+1), t.getName(), t.getComment()};
      //v.add(convertToVector(o));
      dataVector.add(convertToVector(o));
    }
    //setDataVector(v, columnIdentifiers);
    fireTableDataChanged();
  }
}
</code></pre>

### 解説
上記のサンプルでは、`DefaultTableModel`のフィールドにある`dataVector`を表示用に使用し、これとは別にすべての行を保持する`Vector`を作成しています。例えば、奇数行だけ表示するという条件が選択された場合、この条件に適合する行だけを保持用`Vector`から表示用の`dataVector`にコピーすることでフィルタリングを行っています。

`JDK 1.6.0`では、標準でフィルタリング機能が実装されているようです([RowFilterでJTableの行をフィルタリング](http://terai.xrea.jp/Swing/RowFilter.html))。

### 参考リンク
- [RowFilterでJTableの行をフィルタリング](http://terai.xrea.jp/Swing/RowFilter.html)

<!-- dummy comment line for breaking list -->

### コメント
