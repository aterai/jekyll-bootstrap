---
layout: post
title: Hyperlinkを、JLabel、JButton、JEditorPaneで表示
category: swing
folder: HyperlinkLabel
tags: [Html, JLabel, JButton, JEditorPane, HyperlinkListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-11-26

## Hyperlinkを、JLabel、JButton、JEditorPaneで表示
`Hyperlink`を、`JLabel`、`JButton`、`JEditorPane`で表示し、それぞれクリックした時のイベントを取得します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTOIQH0ABI/AAAAAAAAAb4/9QlzkW-7_Es/s800/HyperlinkLabel.png)

### サンプルコード
<pre class="prettyprint"><code>class URILabel extends JLabel {
  private final String href;
  public URILabel(String href) {
    super("&lt;html&gt;&lt;a href='"+href+"'&gt;"+href+"&lt;/a&gt;");
    this.href = href;
    setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
    addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {open(href);}
    });
  }
}
</code></pre>

<pre class="prettyprint"><code>JButton button = new JButton(a);
button.setUI(LinkViewButtonUI.createUI(button));

class LinkViewButtonUI extends BasicButtonUI {
  private final static LinkViewButtonUI linkViewButtonUI = new LinkViewButtonUI();
  public static ButtonUI createUI(JButton b) {
    b.setBorder(BorderFactory.createEmptyBorder(0,0,2,0));
    b.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
    return linkViewButtonUI;
  }
  private LinkViewButtonUI() {
    super();
  }
  private static Dimension size = new Dimension();
  private static Rectangle viewRect = new Rectangle();
  private static Rectangle iconRect = new Rectangle();
  private static Rectangle textRect = new Rectangle();
  @Override public synchronized void paint(Graphics g, JComponent c) {
    AbstractButton b = (AbstractButton) c;
    ButtonModel model = b.getModel();
    Font f = c.getFont();
    g.setFont(f);
    FontMetrics fm = c.getFontMetrics(f);
    //...
</code></pre>

<pre class="prettyprint"><code>JEditorPane editor = new JEditorPane("text/html", "&lt;html&gt;&lt;a href='"+MYSITE+"'&gt;"+MYSITE+"&lt;/a&gt;");
editor.setOpaque(false);
//editor.setBackground(getBackground());
//editor.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editor.setEditable(false); //REQUIRED
editor.addHyperlinkListener(new HyperlinkListener() {
  @Override public void hyperlinkUpdate(HyperlinkEvent e) {
    if(e.getEventType()==HyperlinkEvent.EventType.ACTIVATED) {
      java.awt.Toolkit.getDefaultToolkit().beep();
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、クリックされた時に、リンクをブラウザで開く([Desktopでブラウザを起動](http://terai.xrea.jp/Swing/Desktop.html))代わりに、`beep`音を鳴らしています。

- `JLabel` + `MouseListener`
    - `JLabel`に`MouseListener`を設定しています。
    - リンクの表示には`<a>`タグを使っています。

<!-- dummy comment line for breaking list -->

- `JButton` + `ButtonUI`
    - `JButton`に、文字の描画を変更する`ButtonUI`を設定しています。
        - `Rollover`: アンダーライン
        - `Pressed`: 黒

<!-- dummy comment line for breaking list -->

- `JEditorPane` + `HyperlinkListener`
    - 編集不可にした`JEditorPane`に`HyperlinkListener`を設定しています。
    - リンクの表示には`<a>`タグを使っています。
    - 選択してコピーできます。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JEditorPane (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JEditorPane.html)
- [Link Buttons in Swing - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/link_buttons_in_swing)
    - こちらは、`JButton`+`MatteBorder`で表現しているようです。
- [TransferHandlerでHyperlinkをブラウザにドロップ](http://terai.xrea.jp/Swing/DraggableLinkButton.html)
- [Htmlを使ったJLabelとJEditorPaneの無効化](http://terai.xrea.jp/Swing/DisabledHtmlLabel.html)

<!-- dummy comment line for breaking list -->

### コメント