---
layout: post
category: swing
folder: ModalInternalFrame
title: JInternalFrameをModalにする
tags: [JInternalFrame, GlassPane, Mnemonic, JDesktopPane, JToolTip, JLayeredPane]
author: aterai
pubdate: 2007-10-15T13:17:37+09:00
description: JInternalFrameをModalにして、他のJInternalFrameなどを操作できないようにブロックします。
hreflang:
    href: http://java-swing-tips.blogspot.com/2008/10/modal-internal-frame.html
    lang: en
comments: true
---
## 概要
`JInternalFrame`を`Modal`にして、他の`JInternalFrame`などを操作できないようにブロックします。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTP9wW-lJI/AAAAAAAAAe0/xQ9vJrX3MuQ/s800/ModalInternalFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>//menuItem.setMnemonic(KeyEvent.VK_1);
class ModalInternalFrameAction1 extends AbstractAction {
  public ModalInternalFrameAction1(String label) {
    super(label);
  }
  @Override public void actionPerformed(ActionEvent e) {
    setJMenuEnabled(false);
    JOptionPane.showInternalMessageDialog(
      desktop, "information", "modal1", JOptionPane.INFORMATION_MESSAGE);
    setJMenuEnabled(true);
  }
}
</code></pre>
<pre class="prettyprint"><code>//menuItem.setMnemonic(KeyEvent.VK_2);
class ModalInternalFrameAction2 extends AbstractAction {
  private final JPanel glass = new MyGlassPane();
  public ModalInternalFrameAction2(String label) {
    super(label);
    Rectangle screen = frame.getGraphicsConfiguration().getBounds();
    glass.setBorder(BorderFactory.createEmptyBorder());
    glass.setLocation(0, 0);
    glass.setSize(screen.width, screen.height);
    glass.setOpaque(false);
    glass.setVisible(false);
    desktop.add(glass, JLayeredPane.MODAL_LAYER);
  }
  @Override public void actionPerformed(ActionEvent e) {
    setJMenuEnabled(false);
    glass.setVisible(true);
    JOptionPane.showInternalMessageDialog(
      desktop, "information", "modal2", JOptionPane.INFORMATION_MESSAGE);
    glass.setVisible(false);
    setJMenuEnabled(true);
  }
}
</code></pre>
<pre class="prettyprint"><code>//menuItem.setMnemonic(KeyEvent.VK_3);
//Creating Modal Internal Frames -- Approach 1 and Approach 2
//http://web.archive.org/web/20090803142839/http://java.sun.com/developer/JDCTechTips/2001/tt1220.html
class ModalInternalFrameAction3 extends AbstractAction {
  private final Component orgGlassPane;
  private final JPanel glass = new PrintGlassPane();
  public ModalInternalFrameAction3(String label) {
    super(label);
    orgGlassPane = frame.getGlassPane();
    glass.setVisible(false);
  }
  @Override public void actionPerformed(ActionEvent e) {
    JOptionPane optionPane = new JOptionPane();
    optionPane.setMessage("Hello, World");
    optionPane.setMessageType(JOptionPane.INFORMATION_MESSAGE);
    JInternalFrame modal = optionPane.createInternalFrame(desktop, "modal3");
    removeSystemMenuListener(modal);
    modal.addInternalFrameListener(new InternalFrameAdapter() {
      @Override public void internalFrameClosed(InternalFrameEvent e) {
        glass.setVisible(false);
        frame.setGlassPane(orgGlassPane);
      }
    });
    glass.add(modal);
    //Rectangle screen = desktop.getBounds();
    //modal.setLocation(screen.x + screen.width / 2  - modal.getSize().width / 2,
    //                  screen.y + screen.height / 2 - modal.getSize().height / 2);
    frame.setGlassPane(glass);
    glass.setVisible(true);
    modal.setVisible(true);
    try {
      modal.setSelected(true);
    }catch(java.beans.PropertyVetoException ex) {}
  }
}
</code></pre>

## 解説
- <kbd>Alt+1</kbd>: `JOptionPane.showInternalMessageDialog`メソッドを使用して、簡単なメッセージを表示する`Modal`な`Dialog`を`JDesktopPane`内に表示
    - `JButton`のマウスクリックは無効になるが、`Mnemonic`が無効にならない
        - <kbd>Alt+B</kbd>でボタンを押すことが出来てしまう
        - `Mnemonic`を設定したコンポーネントは`setEnabled(false)`とする必要がある
    - `Mnemonic`を`JMenu`に設定していると`setEnabled(false)`としても、<kbd>Alt</kbd>キーに反応する
        - これは`WindowsLookAndFeel`だけ？
        - この`InternalMessageDialog`を表示している間は、`JMenuBar`をダミーと入れ替えて無効化
    - この`InternalMessageDialog`を閉じない限り、アプリケーションを<kbd>Alt+F4</kbd>などで閉じることは出来ない
    - `InternalMessageDialog`のシステムメニュー(左上のアイコンをクリックすると表示される)がマウスで操作不可能
    - `JToolTip`は正常
        - `showInternalMessageDialog(...)`メソッド内で、`pane.putClientProperty(PopupFactory_FORCE_HEAVYWEIGHT_POPUP, Boolean.TRUE)`(`JDK 1.6.0`の場合の`Key`は、`PopupFactory.forceHeavyWeightPopupKey`) されているため、`JComboBox`などのドロップダウンメニューも正常

<!-- dummy comment line for breaking list -->

- <kbd>Alt+2</kbd>: <kbd>Alt+1</kbd>と同様に`JOptionPane.showInternalMessageDialog`メソッドを使用し、かつ半透明な`GlassPane`を`JLayeredPane.MODAL_LAYER`に追加
    - 動作、制限などは、<kbd>Alt+2</kbd>の`InternalMessageDialog`と同じ
    - `JDesktopPane`内にマスクが掛かる

<!-- dummy comment line for breaking list -->

- <kbd>Alt+3</kbd>: `JFrame`に半透明な`GlassPane`を追加し、そこに`JInternalFrame`を追加することで`Modal`に設定
    - `JFrame`内全体(`JMenuBar`なども含む)にマスクが掛かる
    - `InternalMessageDialog`のシステムメニューが自身のレイヤーより奥に表示されるため、アイコン(`JLabel`)をクリックしても反応しないようにリスナーを除去
    - `JComboBox`を`InternalMessageDialog`に追加すると、そのドロップダウンメニューが裏に表示される
    - この`InternalMessageDialog`を開いていても、アプリケーションを<kbd>Alt+F4</kbd>などで閉じることが出来てしまう

<!-- dummy comment line for breaking list -->

- - - -
- <kbd>Alt+3</kbd>の方法で、`InternalOptionDialog`に`JComboBox`を追加する場合、ドロップダウンメニューを正しく表示させるには、リフレクションを使って`ClientProperty`を設定するしかない？
    - `JInternalFrame#putClientProperty(PopupFactory_FORCE_HEAVYWEIGHT_POPUP, Boolean.TRUE)`とすれば、システムメニューも正常に表示されるが、`JOptionPane.showInternalXXXDialog`では、なぜか`JOptionPane`に設定するようになっている(`JInternalFrame`は使い回ししているから？)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JInternalFrame modal = optionPane.createInternalFrame(desktop, "modal3");
JComboBox combo = new JComboBox(new String[] {"Banana", "Apple", "Pear", "Grape"});
combo.setEditable(true);
try {
  Field field;
  if (System.getProperty("java.version").startsWith("1.6.0")) {
    Class clazz = Class.forName("javax.swing.PopupFactory");
    field = clazz.getDeclaredField("forceHeavyWeightPopupKey");
  } else { //1.7.0, 1.8.0
    Class clazz = Class.forName("javax.swing.ClientPropertyKey");
    field = clazz.getDeclaredField("PopupFactory_FORCE_HEAVYWEIGHT_POPUP");
  }
  field.setAccessible(true);
  modal.putClientProperty(field.get(null), Boolean.TRUE);
}catch(Exception ex) {
  ex.printStackTrace();
}
optionPane.setMessage(combo);
optionPane.setMessageType(JOptionPane.QUESTION_MESSAGE);
</code></pre>

- - - -
[Alexander Potochkin's Blog: Disabling Swing Containers, the final solution?](http://weblogs.java.net/blog/alexfromsun/archive/2008/01/)を参考に(`paint`ではなく、`print`が使用されている)して、`GlassPane`を以下のように修正すると、上記のサンプルの<kbd>Alt+3</kbd>(<kbd>Alt+2</kbd>の場合は、描画が乱れる)は、`Mnemonic`もうまくブロックできるようです。

- `JFrame`のメニューバーの`Mnemonic`もブロックできる
    - `JRootPane`から取得した`LayeredPane`が非表示なので、その子コンポーネント(`JMenuBar`や`ContentPane`など)のキーイベントがすべて無効になる
    - [JRootPane (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JRootPane.html)の図にあるように、`GlassPane`は、`JRootPane`の最上位の子コンポーネントなので、`LayeredPane`を画像として表示している
- `JFrame`のシステムメニューはブロックできない
- モーダルにした`JInternalFrame`のシステムメニューは表示されない
    - ただし表示されないだけで、クリックしてからカーソル移動やダブルクリックなどが動いてしまう
- モーダルにした`JInternalFrame`の右上の閉じるボタンの`JToolTip`が`JDesktopPane`内で表示される場合、空白になる ~~`JDK 6`では`JToolTip`は表示されない~~

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class PrintGlassPane extends JPanel {
  TexturePaint texture = TextureFactory.createCheckerTexture(4);
  public PrintGlassPane() {
    super((LayoutManager)null);
    setOpaque(false);
  }
  @Override public void setVisible(boolean isVisible) {
    boolean oldVisible = isVisible();
    super.setVisible(isVisible);
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if (rootPane != null &amp;&amp; isVisible() != oldVisible) {
      rootPane.getLayeredPane().setVisible(!isVisible);
    }
  }
  @Override public void paintComponent(Graphics g) {
    JRootPane rootPane = SwingUtilities.getRootPane(this);
    if (rootPane != null) {
      //http://weblogs.java.net/blog/alexfromsun/archive/2008/01/
      // it is important to call print() instead of paint() here
      // because print() doesn't affect the frame's double buffer
      rootPane.getLayeredPane().print(g);
    }
    Graphics2D g2 = (Graphics2D) g;
    g2.setPaint(texture);
    g2.fillRect(0, 0, getWidth(), getHeight());
  }
}
</code></pre>

- - - -
`JDK 6`の場合、[Disabled Glass Pane « Java Tips Weblog](http://tips4java.wordpress.com/2008/11/07/disabled-glass-pane/)のようにキー入力を無効にするキーリスナーを追加する方法もあります。

この方法は、`JDK 5`などの場合、`WindowsLookAndFeel`で、<kbd>Alt</kbd>キーを押すとメニューバーにフォーカスが移ることがあります。

## 参考リンク
- [Creating Modal Internal Frames -- Approach 1 and Approach 2](http://web.archive.org/web/20090803142839/http://java.sun.com/developer/JDCTechTips/2001/tt1220.html)
- [How to Use Root Panes](http://docs.oracle.com/javase/tutorial/uiswing/components/rootpane.html)
- [Disabling Swing Containers, the final solution?](http://weblogs.java.net/blog/alexfromsun/archive/2008/01/)
    - [Cursorを砂時計に変更](http://ateraimemo.com/Swing/WaitCursor.html)

<!-- dummy comment line for breaking list -->

## コメント
- ~~[JInternalFrameを半透明にする](http://ateraimemo.com/Swing/TransparentFrame.html)と、同様に`GlassPane`が`Ubuntu`(`GNOME`)などで半透明にならない場合があります。~~ -- *aterai* 2007-10-15 (月) 13:16:07
    - <kbd>Alt+2</kbd>で開いた場合、`JInternalFrame`に`GlassPane`を乗せるのではなく、直接`JDesktopPane`の`JLayeredPane.MODAL_LAYER`に追加するように変更しました。 -- *aterai* 2007-10-16 (火) 17:31:50
- メモ: [Alexander Potochkin's Blog: Disabling Swing Containers, the final solution?](http://weblogs.java.net/blog/alexfromsun/archive/2008/01/)のサンプルでは、`Mnemonic`もちゃんとブロックできているようなので、「あとで調べる & 参考にする」こと。 -- *aterai* 2008-01-25 (金) 17:28:21
- `Mnemonic`を数字キー(<kbd>1</kbd>, <kbd>2</kbd>, <kbd>3</kbd>)に変更 -- *aterai* 2008-04-25 (金) 20:51:49
- すべての`Mnemonic`を一時的に無効化したい場合に、`UIManager.java`の`private static final String disableMnemonicKey = "swing.disablenavaids";`は使えない？ 以下のように、`KeyboardFocusManager.setCurrentKeyboardFocusManager(...)`で、<kbd>Alt</kbd>キーなどを無視する方法もあるが…、もっと簡単な方法を調査中。 -- *aterai* 2013-05-09 (木) 11:46:38

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>KeyboardFocusManager manager = KeyboardFocusManager.getCurrentKeyboardFocusManager();
KeyboardFocusManager.setCurrentKeyboardFocusManager(new DefaultKeyboardFocusManager() {
  @Override public boolean dispatchEvent(AWTEvent e) {
    if (e instanceof KeyEvent) {
      KeyEvent ke = (KeyEvent) e;
      if ((ke.getModifiers() &amp; InputEvent.ALT_DOWN_MASK) != 0) {
        System.out.println("----\n"+ke);
        return false;
      }
    }
    return super.dispatchEvent(e);
  }
});
JComboBox&lt;String&gt; combo = new JComboBox&lt;&gt;(new String[] {"Banana", "Apple", "Pear", "Grape"});
combo.setEditable(true);

JOptionPane.showInternalMessageDialog(
  desktop, combo, "modal1", JOptionPane.INFORMATION_MESSAGE);
KeyboardFocusManager.setCurrentKeyboardFocusManager(manager);
</code></pre>
