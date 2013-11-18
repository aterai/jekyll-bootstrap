---
layout: post
title: JTableの罫線の有無とセルの内余白を変更
category: swing
folder: IntercellSpacing
tags: [JTable]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-05-30

## JTableの罫線の有無とセルの内余白を変更
`JTable`の罫線の表示非表示とセルの内余白を変更します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-zDg_KUxGwU4/TeNHkhhJYGI/AAAAAAAAA8M/G5R8rKLVzUg/s800/IntercellSpacing.png)

### サンプルコード
<pre class="prettyprint"><code>Dimension d = table.getIntercellSpacing();
table.setShowVerticalLines(false);
table.setIntercellSpacing(new Dimension(0,d.height));
//table.setShowHorizontalLines(false);
//table.setIntercellSpacing(new Dimension(d.width,0));
</code></pre>

### 解説
`JTable`の罫線を非表示にしてもセルの内余白が`0`でない場合、選択状態でその内余白が表示されるので、上記のサンプルでは、`JTable#setShowVerticalLines(boolean)`などと一緒に、`JTable#setIntercellSpacing(Dimension)`で余白を`0`に切り替えています。

- 罫線
    - `JTable#setShowVerticalLines(boolean);`
    - `JTable#setShowHorizontalLines(boolean);`
- セルの内余白
    - `JTable#setIntercellSpacing(Dimension intercellSpacing);`
        - `JTable#setRowMargin(intercellSpacing.height);`
        - `JTable#getColumnModel().setColumnMargin(intercellSpacing.width);`

<!-- dummy comment line for breaking list -->

### コメント
