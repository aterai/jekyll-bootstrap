---
layout: post
category: swing
folder: RegexDateFilter
title: JTableのセルに設定した日付をRegexFilterでフィルタリングする
tags: [JTable, RowFilter, Date]
author: aterai
pubdate: 2016-04-11T00:24:26+09:00
description: JTableのセルに設定した日付をRegexFilterなどでフィルタリングするテストを行います。
image: https://lh3.googleusercontent.com/-yjS3rTYWgk0/VwprmN868uI/AAAAAAAAOSs/-HBZ7l1VimsTNtZo7FDk0wwasI3G4wirACCo/s800-Ic42/RegexDateFilter.png
comments: true
---
## 概要
`JTable`のセルに設定した日付を`RegexFilter`などでフィルタリングするテストを行います。

{% download https://lh3.googleusercontent.com/-yjS3rTYWgk0/VwprmN868uI/AAAAAAAAOSs/-HBZ7l1VimsTNtZo7FDk0wwasI3G4wirACCo/s800-Ic42/RegexDateFilter.png %}

## サンプルコード
<pre class="prettyprint"><code>ActionListener al = e -&gt; {
  Object o = e.getSource();
  String txt = field.getText();
  if (r1.equals(o)) {
    sorter.setRowFilter(RowFilter.regexFilter(txt));
  } else if (r2.equals(o)) {
    sorter.setRowFilter(new RegexDateFilter(Pattern.compile(txt)));
  } else {
    sorter.setRowFilter(null);
  }
};

class RegexDateFilter extends RowFilter&lt;TableModel, Integer&gt; {
  private final Matcher matcher;
  protected RegexDateFilter(Pattern pattern) {
    super();
    this.matcher = pattern.matcher("");
  }
  @Override public boolean include(
      Entry&lt;? extends TableModel, ? extends Integer&gt; entry) {
    for (int i = entry.getValueCount() - 1; i &gt;= 0; i--) {
      Object v = entry.getValue(i);
      if (v instanceof Date) {
        matcher.reset(DateFormat.getDateInstance().format(v));
      } else {
        matcher.reset(entry.getStringValue(i));
      }
      if (matcher.find()) {
        return true;
      }
    }
    return false;
  }
}
</code></pre>

## 解説
- `null`
    - フィルタをクリア
- `RowFilter.regexFilter`
    - `RowFilter.regexFilter(txt)`を設定
    - 以下のように、`RowFilter.regexFilter`では`Date#toString()`メソッドが使用され、セルに表示されている文字列ではフィルタリングされない
        
        <pre class="prettyprint"><code>//@see javax/swing/RowFilter.java
        public static abstract class Entry&lt;M, I&gt; {
          // ...
          public String getStringValue(int index) {
            Object value = getValue(index);
            return (value == null) ? "" : value.toString();
          }
          // ...
</code></pre>
    - 例: `12`ではすべての行が非表示だが、`Dec`では`2`行表示される
- `new RowFilter()`
    - `RowFilter<TableModel, Integer>`を継承するフィルタを作成して設定
    - このフィルタでは、以下のように、`DateRenderer`が表示に使用しているデフォルトの`DateFormat`を使用して`Date`を文字列に変換し、フィルタリングを行う
        
        <pre class="prettyprint"><code>//@see javax/swing/JTable.java
        static class DateRenderer extends DefaultTableCellRenderer.UIResource {
          public void setValue(Object value) {
            // ...
            DateFormat formatter = DateFormat.getDateInstance();
            setText((value == null) ? "" : formatter.format(value));
          }
        }
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `JDK 1.8.0`以上なら、`toString()`でロケールを無視する`Date`ではなく`LocalDateTime`を使用すれば、`LocalDateTime#toString()`が`ISO-8601`形式の文字列を返すので面倒が少ない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>  LocalDateTime d = LocalDateTime.of(2002, 12, 31, 0, 0);
  Object[][] data = {
    {date,  d},
    {start, d.minus(2, ChronoUnit.DAYS)},
    {end,   d.plus(7, ChronoUnit.DAYS)}
  };
  DefaultTableModel model = new DefaultTableModel(data, new String[] {"Date", "LocalDateTime"}) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return column == 0 ? Date.class : column == 1 ? LocalDateTime.class : Object.class;
  }
};
</code></pre>

## 参考リンク
- [RowFilter#regexFilter(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/RowFilter.html#regexFilter-java.lang.String-int...-)
- [RowFilter#dateFilter(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/RowFilter.html#dateFilter-javax.swing.RowFilter.ComparisonType-java.util.Date-int...-)
    - `Date`を文字列ではなく、日付として各条件を指定しフィルタリングする場合は、`RowFilter#dateFilter(...)`を使用する

<!-- dummy comment line for breaking list -->

## コメント
