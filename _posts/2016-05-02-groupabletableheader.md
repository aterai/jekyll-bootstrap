---
layout: post
category: swing
folder: GroupableTableHeader
title: JTableHeaderでTableColumnのグループ化を行う
tags: [JTable, JTableHeader, TableColumn]
author: aterai
pubdate: 2016-05-02T00:35:46+09:00
description: TableColumnのグループ化を可能にし、JTableHeaderでの列結合を実現します。
comments: true
---
## 概要
`TableColumn`のグループ化を可能にし、`JTableHeader`での列結合を実現します。~~[Groupable Header - JTable Examples 1](http://www2.gol.com/users/tame/swing/examples/JTableExamples1.html)~~からの引用です。

{% download https://lh3.googleusercontent.com/-DIZZyiOX9YU/VyYbXr9opNI/AAAAAAAAOTs/QhLBqtw5Z34ULclU9aZHnVjnEZMJvhJmgCCo/s800/GroupableTableHeader.png %}

## サンプルコード
<pre class="prettyprint"><code>/** GroupableTableHeader
 * http://www2.gol.com/users/tame/swing/examples/JTableExamples1.html
 * @version 1.0 10/20/98
 * @author Nobuo Tamemasa
 * modified by aterai aterai@outlook.com
 */
class GroupableTableHeader extends JTableHeader {
  private transient List&lt;ColumnGroup&gt; columnGroups;

  protected GroupableTableHeader(TableColumnModel model) {
    super(model);
  }
  @Override public void updateUI() {
    super.updateUI();
    setUI(new GroupableTableHeaderUI());
  }
  //@Override public boolean getReorderingAllowed() {
  //  return false;
  //}
  @Override public void setReorderingAllowed(boolean b) {
    super.setReorderingAllowed(false);
  }
  public void addColumnGroup(ColumnGroup g) {
    if (columnGroups == null) {
      columnGroups = new ArrayList&lt;&gt;();
    }
    columnGroups.add(g);
  }
  public List&lt;?&gt; getColumnGroups(TableColumn col) {
    if (columnGroups == null) {
      return Collections.emptyList();
    }
    for (ColumnGroup cGroup : columnGroups) {
      List&lt;?&gt; groups = cGroup.getColumnGroupList(col, new ArrayList&lt;Object&gt;());
      if (!groups.isEmpty()) {
        return groups;
      }
    }
    return Collections.emptyList();
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTableHeader`に列のグループ化設定を追加し、`BasicTableHeaderUI#paint(...)`をオーバーライドしてヘッダセルの描画領域を変更することで、`TableColumn`の列結合を実現しています。

- ~~[オリジナル](http://www2.gol.com/users/tame/swing/examples/JTableExamples1.html)~~からの主な変更点:
    - `header.getColumnModel().getColumnMargin()`で取得した余白を無視(ヘッダセルと本体セルがずれてしまう)
    - グループ化設定の保持に、`Vector`ではなく`ArrayList`を使用
    - グループ化設定がない場合は、`null`ではなく`Collections.emptyList()`を返す
    - `BasicTableHeaderUI`からコピーしている`private`メソッド？を最新版に更新

<!-- dummy comment line for breaking list -->

## 参考リンク
- ~~[Groupable Header - JTable Examples 1](http://www2.gol.com/users/tame/swing/examples/JTableExamples1.html)~~
    - オリジナル版
- [Groupable(Group) Header Example : Grid Table « Swing Components « Java](http://www.java2s.com/Code/Java/Swing-Components/GroupableGroupHeaderExample.htm)
    - `revised by Java2s.com`でいくつか変更点がある

<!-- dummy comment line for breaking list -->

## コメント
