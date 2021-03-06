---
layout: post
category: swing
folder: SelectableToolTip
title: JToolTipの文字列を選択・コピー可能にする
tags: [JToolTip, JPopupMenu, JEditorPane]
author: aterai
pubdate: 2020-02-03T17:37:47+09:00
description: JToolTipの代わりにJPopupMenuを表示し、その内部に配置したコンポーネントのクリックや文字列の選択・コピーを可能にします。
image: https://drive.google.com/uc?id=1gSgkKvGUaTX9rESzzcCHyhNRREYr22cq
hreflang:
    href: https://java-swing-tips.blogspot.com/2020/05/make-text-in-jtooltip-selectable-and.html
    lang: en
comments: true
---
## 概要
`JToolTip`の代わりに`JPopupMenu`を表示し、その内部に配置したコンポーネントのクリックや文字列の選択・コピーを可能にします。

{% download https://drive.google.com/uc?id=1gSgkKvGUaTX9rESzzcCHyhNRREYr22cq %}

## サンプルコード
<pre class="prettyprint"><code>JEditorPane hint = new JEditorPane();
hint.setEditorKit(new HTMLEditorKit());
hint.setEditable(false);
hint.setOpaque(false);

JCheckBox check = new JCheckBox();
check.setOpaque(false);

JPanel panel = new JPanel(new BorderLayout());
panel.add(hint);
panel.add(check, BorderLayout.EAST);

JPopupMenu popup = new JPopupMenu();
popup.add(new JScrollPane(panel));
popup.setBorder(BorderFactory.createEmptyBorder());

JEditorPane editor = new JEditorPane() {
  @Override public JToolTip createToolTip() {
    JToolTip tip = super.createToolTip();
    tip.addHierarchyListener(e -&gt; {
      if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0
            &amp;&amp; e.getComponent().isShowing()) {
        panel.setBackground(tip.getBackground());
        popup.show(tip, 0, 0);
      }
    });
    return tip;
  }
};
editor.setEditorKit(new HTMLEditorKit());
editor.setText(HTML_TEXT);
editor.setEditable(false);
editor.addHyperlinkListener(e -&gt; {
  JEditorPane editorPane = (JEditorPane) e.getSource();
  if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
    JOptionPane.showMessageDialog(editorPane, "You click the link with the URL " + e.getURL());
  } else if (e.getEventType() == HyperlinkEvent.EventType.ENTERED) {
    editorPane.setToolTipText("");
    Optional.ofNullable(e.getSourceElement())
        .map(elem -&gt; (AttributeSet) elem.getAttributes().getAttribute(HTML.Tag.A))
        .ifPresent(attr -&gt; {
          String title = Objects.toString(attr.getAttribute(HTML.Attribute.TITLE));
          String url = Objects.toString(e.getURL());
          // String url = Objects.toString(attr.getAttribute(HTML.Attribute.HREF));
          hint.setText(String.format("&lt;html&gt;%s: &lt;a href='%s'&gt;%s&lt;/a&gt;", title, url, url));
          popup.pack();
        });
  } else if (e.getEventType() == HyperlinkEvent.EventType.EXITED) {
    editorPane.setToolTipText(null);
  }
});
</code></pre>

## 解説
- `JComponent#createToolTip()`メソッドをオーバーライドし、`JToolTip`に`HierarchyListener`を追加
- `JToolTip`が表示状態になったらその`JToolTip`を親にして`JPopupMenu`を表示
    - `JToolTip`は`JPopupMenu`の背後に隠れている
    - `JPopupMenu`には`JMenuItem`ではなく`JEditorPane`と`JCheckBox`を配置した`JPanel`を追加している
- マウスカーソルを移動して親の`JToolTip`が非表示になっても`JPopupMenu`は閉じないので、内部の`JCheckBox`をクリックしたり`JEditorPane`の文字列を選択し<kbd>Ctrl-C</kbd>などでコピー可能
    - 通常の`JPopupMenu`なので親`JFrame`などをクリックしてフォーカスが移動すると非表示になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JButtons inside JTooltip (Swing / AWT / SWT forum at Coderanch)](https://coderanch.com/t/538128/java/JButtons-JTooltip)

<!-- dummy comment line for breaking list -->

## コメント
