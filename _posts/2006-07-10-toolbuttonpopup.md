---
layout: post
title: JToggleButtonからポップアップメニューを開く
category: swing
folder: ToolButtonPopup
tags: [JToggleButton, JPopupMenu, JToolBar, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-07-10

## JToggleButtonからポップアップメニューを開く
クリックするとポップアップメニューを表示する`JToggleButton`を作成し、これをツールバーに追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTVg5xIBaI/AAAAAAAAAnw/ds2ybXI2lUE/s800/ToolButtonPopup.png)

### サンプルコード
<pre class="prettyprint"><code>class MenuArrowIcon implements Icon {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D)g;
    g2.setPaint(Color.BLACK);
    g2.translate(x,y);
    g2.drawLine( 2, 3, 6, 3 );
    g2.drawLine( 3, 4, 5, 4 );
    g2.drawLine( 4, 5, 4, 5 );
    g2.translate(-x,-y);
  }
  @Override public int getIconWidth()  { return 9; }
  @Override public int getIconHeight() { return 9; }
}
class MenuToggleButton extends JToggleButton {
  private static final Icon i = new MenuArrowIcon();
  public MenuToggleButton() {
    this("", null);
  }
  public MenuToggleButton(Icon icon) {
    this("", icon);
  }
  public MenuToggleButton(String text) {
    this(text, null);
  }
  public MenuToggleButton(String text, Icon icon) {
    super();
    Action a = new AbstractAction(text) {
      @Override public void actionPerformed(ActionEvent ae) {
        MenuToggleButton b = (MenuToggleButton)ae.getSource();
        if(pop!=null) pop.show(b, 0, b.getHeight());
      }
    };
    a.putValue(Action.SMALL_ICON, icon);
    setAction(a);
    setFocusable(false);
    setBorder(BorderFactory.createEmptyBorder(4, 4, 4, 4+i.getIconWidth()));
  }
  protected JPopupMenu pop;
  @Override public void setPopupMenu(final JPopupMenu pop) {
    this.pop = pop;
    pop.addPopupMenuListener(new PopupMenuListener() {
      @Override public void popupMenuCanceled(PopupMenuEvent e) {}
      @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {}
      @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
        setSelected(false);
      }
    });
  }
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    Dimension dim = getSize();
    Insets ins = getInsets();
    int x = dim.width-ins.right;
    int y = ins.top+(dim.height-ins.top-ins.bottom-i.getIconHeight())/2;
    i.paintIcon(this, g, x, y);
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JToggleButton`の右側に余白を設定して、そこに下向きの矢印を上書きしています。

### 参考リンク
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)
    - アイコン(矢印ではない)を利用しています。
- [Swing - Swing bug? cannot set width of JToggleButton](https://forums.oracle.com/message/5809491)

<!-- dummy comment line for breaking list -->

### コメント
- いつもお世話になっております。`JToggleButton`を`On/Off`時、背景色を変える方法はありますか？`jToggleButton.setBackground(Color.RED);`で試してみましたが、色変化はありませんでした。ご教示、よろしくお願いいたします -- [Panda](http://terai.xrea.jp/Panda.html) 2011-04-04 (月) 14:23:21
- こんばんは。`JToggleButton#setBackground(Color)`は、`LookAndFeel`によっては適用されない場合があります。このため、独自の`ToggleButtonUI`を用意したり、例えば以下のような方法を使用する必要があります。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-04-04 (月) 17:15:55
    - 例`1`: 文字列から背景色、縁などのすべてを含めたアイコンを用意して`setSelectedIcon`で設定する
    - 例`2`: `setContentAreaFilled(false);`として、自前で選択時の背景を描画する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JToggleButton button = new JToggleButton("text", icon) {
  @Override public void paintComponent(Graphics g) {
    if(getModel().isSelected()) {
      Graphics2D g2 = (Graphics2D)g.create();
      g2.setColor(getBackground());
      g2.fillRoundRect(0,0,getWidth(),getHeight(),4,4);
      g2.dispose();
    }
    super.paintComponent(g);
    //......
  }
};
button.setBackground(Color.RED);
button.setContentAreaFilled(false);
</code></pre>
