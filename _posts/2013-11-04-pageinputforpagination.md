---
layout: post
title: JTableのPaginationとSwingWorkerでの逐次読み込み
category: swing
folder: PageInputForPagination
tags: [JTable, RowFilter, SwingWorker, JButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-11-04

## JTableのPaginationとSwingWorkerでの逐次読み込み
`JTable`で`RowFilter`を使った`Pagination`と`SwingWorker`での逐次読み込みを行います。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-1qIJd4HlwkQ/UnaN9fNNZtI/AAAAAAAAB5Y/JqssphQAq3Q/s800/PageInputForPagination.png)

### サンプルコード
<pre class="prettyprint"><code>worker = new SwingWorker&lt;String, List&lt;Object[]&gt;&gt;() {
  private int max = 2013;
  @Override public String doInBackground() {
    int current = 1;
    int c = max/itemsPerPage;
    int i = 0;
    while(i&lt;c &amp;&amp; !isCancelled()) {
      current = makeRowListAndPublish(current, itemsPerPage);
      i++;
    }
    int m = max%itemsPerPage;
    if(m&gt;0) {
      makeRowListAndPublish(current, m);
    }
    return "Done";
  }
  private int makeRowListAndPublish(int current, int size) {
    try{
      Thread.sleep(500); //dummy
    }catch(Exception ex) {
      ex.printStackTrace();
    }
    List&lt;Object[]&gt; result = new ArrayList&lt;Object[]&gt;(size);
    int j = current;
    while(j&lt;current+size) {
      result.add(new Object[] {j, "Test: "+j, (j%2==0)?"":"comment..."});
      j++;
    }
    publish(result);
    return j;
  }
  @Override protected void process(List&lt;List&lt;Object[]&gt;&gt; chunks) {
    for(List&lt;Object[]&gt; list: chunks) {
      for(Object[] o: list) {
        model.addRow(o);
      }
    }
    int rowCount = model.getRowCount();
    maxPageIndex = (rowCount/itemsPerPage) + (rowCount%itemsPerPage==0?0:1);
    initFilterAndButton();
  }
  @Override public void done() {
    String text = null;
    if(isCancelled()) {
      text = "Cancelled";
    }else{
      try{
        text = get();
      }catch(Exception ex) {
        ex.printStackTrace();
        text = "Exception";
      }
    }
    table.setEnabled(true);
  }
};
worker.execute();
//...
private static final int itemsPerPage = 100;
private int maxPageIndex;
private int currentPageIndex = 1;
private void initFilterAndButton() {
  sorter.setRowFilter(new RowFilter&lt;TableModel, Integer&gt;() {
    @Override public boolean include(
        Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
      int ti = currentPageIndex - 1;
      int ei = entry.getIdentifier();
      return ti*itemsPerPage&lt;=ei &amp;&amp; ei&lt;ti*itemsPerPage+itemsPerPage;
    }
  });
  first.setEnabled(currentPageIndex&gt;1);
  prev.setEnabled(currentPageIndex&gt;1);
  next.setEnabled(currentPageIndex&lt;maxPageIndex);
  last.setEnabled(currentPageIndex&lt;maxPageIndex);
  field.setText(Integer.toString(currentPageIndex));
  label.setText(String.format("/ %d", maxPageIndex));
}
</code></pre>

### 解説
上記のサンプルでは、[RowFilterでJTableのページ分割](http://terai.xrea.jp/Swing/TablePagination.html)に以下の変更を追加しています。

- `JTextField`に数値を入力して指定ページにジャンプ
- `First`, `Prev`, `Next`, `Last`に`JRadioButton`ではなく、`JButton`を使用
- `SwingWorker`を使ってページ単位での逐次読み込み(最大ページの表示を更新)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [RowFilterでJTableのページ分割](http://terai.xrea.jp/Swing/TablePagination.html)

<!-- dummy comment line for breaking list -->

### コメント