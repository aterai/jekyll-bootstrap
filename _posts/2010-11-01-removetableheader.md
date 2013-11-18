---
layout: post
title: JTableHeaderを非表示にする
category: swing
folder: RemoveTableHeader
tags: [JTable, JTableHeader, JScrollPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-11-01

## JTableHeaderを非表示にする
`JTableHeader`の表示、非表示を切り替えます。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTRpYOxz3I/AAAAAAAAAhg/7HdNawHaulI/s800/RemoveTableHeader.png)

### サンプルコード
<pre class="prettyprint"><code>final JScrollPane scrollPane = new JScrollPane(table);
JCheckBox check = new JCheckBox("JTableHeader visible: ", true);
check.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    JCheckBox cb = (JCheckBox)e.getSource();
    //table.getTableHeader().setVisible(cb.isSelected());
    scrollPane.getColumnHeader().setVisible(cb.isSelected());
    scrollPane.revalidate();
  }
});
</code></pre>

### 解説
上記のサンプルでは、`table.setTableHeader(null)`や、`table.setTableHeader(new JTableHeader(table.getColumnModel()))`は使用せず、`JTable`を配置した`JScrollPane`の`JScrollPane#getColumnHeader().setVisible(boolean)`メソッドを使って、`JTableHeader`の表示、非表示を変更しています。

### コメント
