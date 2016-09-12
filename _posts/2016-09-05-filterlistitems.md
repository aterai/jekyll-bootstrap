---
layout: post
category: swing
folder: FilterListItems
title: JListのアイテムをフィルタリングして表示
tags: [JList, ListCellRenderer, Pattern]
author: aterai
pubdate: 2016-09-05T00:18:48+09:00
description: JListのアイテムのタイトル文字列に対して、正規表現による表示フィルタリングを実行します。
image: https://drive.google.com/uc?export=view&id=1po5ebXxijKnGitb-gGFQv-USKEVDS9IaBQ
comments: true
---
## 概要
`JList`のアイテムのタイトル文字列に対して、正規表現による表示フィルタリングを実行します。

{% download https://drive.google.com/uc?export=view&id=1po5ebXxijKnGitb-gGFQv-USKEVDS9IaBQ %}

## サンプルコード
<pre class="prettyprint"><code>DefaultListModel&lt;ListItem&gt; model = new DefaultListModel&lt;&gt;();
JList&lt;ListItem&gt; list = new JList&lt;ListItem&gt;(model) {
  @Override public void updateUI() {
    setSelectionForeground(null);
    setSelectionBackground(null);
    setCellRenderer(null);
    super.updateUI();
    setLayoutOrientation(JList.HORIZONTAL_WRAP);
    setVisibleRowCount(0);
    setFixedCellWidth(82);
    setFixedCellHeight(64);
    setBorder(BorderFactory.createEmptyBorder(5, 10, 5, 10));
    setCellRenderer(new ListItemListCellRenderer&lt;ListItem&gt;());
    getSelectionModel().setSelectionMode(
        ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
  }
};
private Optional&lt;Pattern&gt; getPattern() {
  try {
    return Optional.ofNullable(field.getText())
                   .filter(s -&gt; !s.isEmpty())
                   .map(Pattern::compile);
  } catch (PatternSyntaxException ex) {
    return Optional.empty();
  }
}
private void filter() {
  getPattern().ifPresent(pattern -&gt; {
    List&lt;ListItem&gt; selected = list.getSelectedValuesList();
    model.clear();
    Stream.of(defaultModel)
          .filter(item -&gt; pattern.matcher(item.title).find())
          .forEach(model::addElement);
    for (ListItem item : selected) {
      int i = model.indexOf(item);
      list.addSelectionInterval(i, i);
    }
  });
}
</code></pre>

## 解説
上記のサンプルでは、ニュースペーパー・スタイルレイアウトに設定した`JList`で、アイテム(セル)のタイトル文字列が`JTextField`に入力したパターンにマッチするかどうかによる表示のフィルタリングを行っています。

- - - -
- `JList`デフォルトのセルを垂直方向に`1`列に並べたレイアウトで、フィルタリングを行う場合は、ヘッダを非表示にした`JTable`と`RowFilter`で代用することが可能

<!-- dummy comment line for breaking list -->

## コメント