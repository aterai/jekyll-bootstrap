---
layout: post
category: swing
folder: ToolButtonPopup
title: JToggleButtonからポップアップメニューを開く
tags: [JToggleButton, JPopupMenu, JToolBar, Icon]
author: aterai
pubdate: 2006-07-10T10:10:27+09:00
description: クリックするとポップアップメニューを表示するJToggleButtonを作成し、これをツールバーに追加します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVg5xIBaI/AAAAAAAAAnw/ds2ybXI2lUE/s800/ToolButtonPopup.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/12/adding-jpopupmenu-to-jtoolbar-button.html
    lang: en
comments: true
---
## 概要
クリックするとポップアップメニューを表示する`JToggleButton`を作成し、これをツールバーに追加します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTVg5xIBaI/AAAAAAAAAnw/ds2ybXI2lUE/s800/ToolButtonPopup.png %}

## サンプルコード
<pre class="prettyprint"><code>class MenuArrowIcon implements Icon {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(Color.BLACK);
    g2.translate(x, y);
    g2.drawLine(2, 3, 6, 3);
    g2.drawLine(3, 4, 5, 4);
    g2.drawLine(4, 5, 4, 5);
    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return 9;
  }
  @Override public int getIconHeight() {
    return 9;
  }
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
        MenuToggleButton b = (MenuToggleButton) ae.getSource();
        if (pop != null) {
          pop.show(b, 0, b.getHeight());
        }
      }
    };
    a.putValue(Action.SMALL_ICON, icon);
    setAction(a);
    setFocusable(false);
    setBorder(BorderFactory.createEmptyBorder(4, 4, 4, 4 + i.getIconWidth()));
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
    int x = dim.width - ins.right;
    int y = ins.top + (dim.height - ins.top - ins.bottom - i.getIconHeight()) / 2;
    i.paintIcon(this, g, x, y);
  }
}
</code></pre>

## 解説
- `JToggleButton`の右側に余白を設定して、そこに下向きの矢印アイコンを描画
- `JToggleButton`に`ActionListener`を追加し、クリックすると`JPopupMenu#show(...)`メソッドで`JPopupMenu`を表示
    - `JPopupMenu`の表示位置は、クリック位置ではなく`JToggleButton`の下辺になるよう調整

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)
- [Swing - Swing bug? cannot set width of JToggleButton](https://community.oracle.com/thread/1375327)

<!-- dummy comment line for breaking list -->

## コメント
- いつもお世話になっております。`JToggleButton`を`On/Off`時、背景色を変える方法はありますか？`jToggleButton.setBackground(Color.RED);`で試してみましたが、色変化はありませんでした。ご教示、よろしくお願いいたします -- *Panda* 2011-04-04 (月) 14:23:21
- こんばんは。`JToggleButton#setBackground(Color)`は、`LookAndFeel`によっては適用されない場合があります。このため、独自の`ToggleButtonUI`を用意したり、例えば以下のような方法を使用する必要があります。 -- *aterai* 2011-04-04 (月) 17:15:55
    - 例`1`: 文字列から背景色、縁などのすべてを含めたアイコンを用意して`setSelectedIcon`で設定する
    - 例`2`: `setContentAreaFilled(false);`として、自前で選択時の背景を描画する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JToggleButton button = new JToggleButton("text", icon) {
  @Override protected void paintComponent(Graphics g) {
    if (getModel().isSelected()) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setColor(getBackground());
      g2.fillRoundRect(0, 0, getWidth(), getHeight(), 4, 4);
      g2.dispose();
    }
    super.paintComponent(g);
    // ...
  }
};
button.setBackground(Color.RED);
button.setContentAreaFilled(false);
</code></pre>
