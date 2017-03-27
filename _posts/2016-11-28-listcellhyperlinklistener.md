---
layout: post
category: swing
folder: ListCellHyperlinkListener
title: JListのセルレンダラーとして設定したJEditorPaneからHyperlinkEventを取得する
tags: [JList, JEditorPane, ListCellRenderer, HyperlinkListener, MouseListener, Html]
author: aterai
pubdate: 2016-11-28T02:00:47+09:00
description: JListのセルレンダラーとして使用しているJEditorPaneに複数リンクを表示し、マウスクリックイベントを転送してHyperlinkEventが発生するように設定します。
image: https://drive.google.com/uc?export=view&id=1ZRAf_BbeW7l2RWn7LDGbJAZwkwtXgKZuuA
comments: true
---
## 概要
`JList`のセルレンダラーとして使用している`JEditorPane`に複数リンクを表示し、マウスクリックイベントを転送して`HyperlinkEvent`が発生するように設定します。

{% download https://drive.google.com/uc?export=view&id=1ZRAf_BbeW7l2RWn7LDGbJAZwkwtXgKZuuA %}

## サンプルコード
<pre class="prettyprint"><code>DefaultListModel&lt;SiteItem&gt; m = new DefaultListModel&lt;&gt;();
m.addElement(new SiteItem("aterai",
  Arrays.asList("http://ateraimemo.com", "https://github.com/aterai")));
m.addElement(new SiteItem("example",
  Arrays.asList("http://www.example.com", "https://www.example.com")));

JList&lt;SiteItem&gt; list = new JList&lt;&gt;(m);
list.setFixedCellHeight(120);
list.setCellRenderer(new SiteListItemRenderer());
list.addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    Point pt = e.getPoint();
    int index = list.locationToIndex(pt);
    if (index &gt;= 0) {
      SiteItem item = list.getModel().getElementAt(index);
      Component c = list.getCellRenderer().getListCellRendererComponent(
          list, item, index, false, false);
      if (c instanceof JEditorPane) {
        Rectangle r = list.getCellBounds(index, index);
        c.setBounds(r);
        pt.translate(-r.x, -r.y);
        c.dispatchEvent(new MouseEvent(
            c, e.getID(), e.getWhen(), e.getModifiers() | e.getModifiersEx(),
            pt.x, pt.y, e.getClickCount(), e.isPopupTrigger()));
      }
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JList`に設定した`MouseListener`のクリックイベントをその`ListCellRenderer`として使用している`JEditorPane`に`dispatchEvent`で転送し、`HyperlinkListener`でリンククリックイベントが取得できるように設定しています。

- `MouseEvent`は、そのクリック位置を`JList`から`JEditorPane`相対に変更する必要がある
    - `SwingUtilities.convertMouseEvent(list, e, editor)`ではうまく変換できないので、自前で位置を変換し、`new MouseEvent(...)`でイベントを作り直している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JListのセル中に配置したコンポーネント毎にカーソルを変更する](http://ateraimemo.com/Swing/CursorOfCellComponent.html)
    - `JList`からセルレンダラーへの座標変換は、こちらと同じものを使用

<!-- dummy comment line for breaking list -->

## コメント
