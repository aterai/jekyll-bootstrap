---
layout: post
category: swing
folder: AccordionPanel
title: JPanelをアコーディオン風に展開
tags: [JPanel, BorderLayout]
author: aterai
pubdate: 2004-11-08T01:08:01+09:00
description: JPanelの展開、折り畳みをアコーディオン風に行います。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTHVHwFBII/AAAAAAAAARA/QX4AmSbPoHs/s800/AccordionPanel.png
comments: true
---
## 概要
`JPanel`の展開、折り畳みをアコーディオン風に行います。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTHVHwFBII/AAAAAAAAARA/QX4AmSbPoHs/s800/AccordionPanel.png %}

## サンプルコード
<pre class="prettyprint"><code>abstract class AbstractExpansionPanel extends JPanel {
  private final String title;
  private final JLabel label;
  private final JPanel panel;
  public abstract JPanel makePanel();
  public AbstractExpansionPanel(String title) {
    super(new BorderLayout());
    this.title = title;
    label = new JLabel("\u25BC " + title) {
      @Override protected void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D) g.create();
        //Insets ins = getInsets();
        g2.setPaint(new GradientPaint(
            50, 0, Color.WHITE, getWidth(), getHeight(),
            new Color(200, 200, 255)));
        g2.fillRect(0, 0, getWidth(), getHeight());
        g2.dispose();
        super.paintComponent(g);
      }
    };
    label.addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        initPanel();
      }
    });
    label.setForeground(Color.BLUE);
    label.setBorder(BorderFactory.createEmptyBorder(2, 5, 2, 2));
    add(label, BorderLayout.NORTH);
    panel = makePanel();
    panel.setVisible(false);
    panel.setOpaque(true);
    panel.setBackground(new Color(240, 240, 255));
    Border outBorder = BorderFactory.createMatteBorder(0, 2, 2, 2, Color.WHITE);
    Border inBorder = BorderFactory.createEmptyBorder(10, 10, 10, 10);
    Border border = BorderFactory.createCompoundBorder(outBorder, inBorder);
    panel.setBorder(border);
    add(panel);
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = label.getPreferredSize();
    if (panel.isVisible()) {
      d.height += panel.getPreferredSize().height;
    }
    return d;
  }
  @Override public Dimension getMaximumSize() {
    Dimension d = getPreferredSize();
    d.width = Short.MAX_VALUE;
    return d;
  }
  protected void initPanel() {
    panel.setVisible(!panel.isVisible());
    label.setText(String.format(
        "%s %s", panel.isVisible() ? "\u25B3" : "\u25BC", title));
    revalidate();
    //fireExpansionEvent();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        panel.scrollRectToVisible(panel.getBounds());
      }
    });
  }
}
</code></pre>

## 解説
各パネルに配置されたタイトルラベルがクリックされた場合、`JPanel#setVisible(boolean)`メソッドを使って、パネルの表示・非表示を切り替えています。

また、パネルを非表示にするだけでは、その高さが変更されないので、以下のように、`JPanel#getPreferredSize()`もオーバーライドしています。

<pre class="prettyprint"><code>@Override public Dimension getPreferredSize() {
  Dimension d = label.getPreferredSize();
  if (panel.isVisible()) {
    d.height += panel.getPreferredSize().height;
  }
  return d;
}
</code></pre>

- - - -
[L2FProd.com - Common Components](http://common.l2fprod.com/) にある`JTaskPane`で、アニメーション付きのパネルの展開や折り畳みが可能です。ソースも公開されているので、`com.l2fprod.common.swing.JCollapsiblePane`などが参考になります。

## 参考リンク
- [JPanelの展開と折り畳み](http://ateraimemo.com/Swing/ExpandablePanel.html)
- [BoxLayoutでリスト状に並べる](http://ateraimemo.com/Swing/ComponentList.html)
- [JTreeのノードを検索する](http://ateraimemo.com/Swing/SearchBox.html)
    - アニメーションさせる場合のサンプル

<!-- dummy comment line for breaking list -->

## コメント
- `SpringLayout`を`BoxLayout`に変更。 -- *aterai* 2009-05-15 (金) 22:33:23
- 不要なコードを削除。 -- *aterai* 2010-11-16 (火) 21:29:33
- 不要(になった？)なリスナクラスなどを削除。 -- *aterai* 2012-08-21 (火) 16:33:17

<!-- dummy comment line for breaking list -->
