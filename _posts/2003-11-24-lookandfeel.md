---
layout: post
category: swing
folder: LookAndFeel
title: Look and Feelの変更
tags: [LookAndFeel, JMenuBar]
author: aterai
pubdate: 2003-11-24
description: メニューバーから選択したLook and Feelを起動中のアプリケーションに適用します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPf78s81I/AAAAAAAAAeE/DIOTnqtAOnY/s800/LookAndFeel.png
comments: true
---
## 概要
メニューバーから選択した`Look and Feel`を起動中のアプリケーションに適用します。以下のサンプルコードは、`%JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java`から引用改変したものです。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPf78s81I/AAAAAAAAAeE/DIOTnqtAOnY/s800/LookAndFeel.png %}

## サンプルコード
<pre class="prettyprint"><code>// %JAVA_HOME%/demo/jfc/SwingSet2/src/SwingSet2.java
// Possible Look &amp; Feels
private static final String MAC     = "com.sun.java.swing.plaf.mac.MacLookAndFeel";
private static final String METAL   = "javax.swing.plaf.metal.MetalLookAndFeel";
private static final String MOTIF   = "com.sun.java.swing.plaf.motif.MotifLookAndFeel";
private static final String WINDOWS = "com.sun.java.swing.plaf.windows.WindowsLookAndFeel";
private static final String GTK     = "com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
// JDK 1.6.0_10
// private static final String NIMBUS  = "com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel";
// JDK 1.7.0
private static final String NIMBUS  = "javax.swing.plaf.nimbus.NimbusLookAndFeel";

// The current Look &amp; Feel
private static String currentLookAndFeel = METAL;
private final ButtonGroup lafMenuGroup = new ButtonGroup();
public JMenuItem createLafMenuItem(JMenu menu, String label, String laf) {
  JMenuItem mi = menu.add(new JRadioButtonMenuItem(label));
  lafMenuGroup.add(mi);
  mi.addActionListener(new ChangeLookAndFeelAction(laf));
  mi.setEnabled(isAvailableLookAndFeel(laf));
  return mi;
}
protected static boolean isAvailableLookAndFeel(String laf) {
  try {
    Class lnfClass = Class.forName(laf);
    LookAndFeel newLAF = (LookAndFeel) lnfClass.newInstance();
    return newLAF.isSupportedLookAndFeel();
  } catch (Exception e) {
    return false;
  }
}
// ...
private class ChangeLookAndFeelAction extends AbstractAction {
  private final String laf;
  protected ChangeLookAndFeelAction(String laf) {
    super("ChangeTheme");
    this.laf = laf;
  }
  @Override public void actionPerformed(ActionEvent e) {
    setLookAndFeel(laf);
  }
}
private void setLookAndFeel(String laf) {
  if (currentLookAndFeel.equals(laf)) return;
  currentLookAndFeel = laf;
  try {
    UIManager.setLookAndFeel(currentLookAndFeel);
    SwingUtilities.updateComponentTreeUI(frame);
  } catch (Exception ex) {
    ex.printStackTrace();
    System.out.println("Failed loading L&amp;F: " + currentLookAndFeel);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`metal`、`motif`、`windows`などの`LookAndFeel`を予め用意しておき、`isAvailableLookAndFeel(...)`メソッドで、それらが実行した環境で使用できるかを調べてメニューの選択可・不可を変更しています。

`Look and Feel`を切り替えて各種コンポーネントの表示などを比較したい場合は、`%JAVA_HOME%/demo/jfc/SwingSet2/SwingSet2.jar`が便利です。

- - - -
`SwingSet3`では、`UIManager.getInstalledLookAndFeels()`メソッドを使って利用可能な`LookAndFeel`の一覧を取得し、これをメニューに表示しているようです。

- [LookAndFeelの一覧を取得する](https://ateraimemo.com/Swing/InstalledLookAndFeels.html)

<!-- dummy comment line for breaking list -->

- - - -
`java.exe`などのコマンドオプションでデフォルトの`Look and Feel`を変更する場合は以下のように指定します。

	java.exe -Dswing.defaultlaf=com.sun.java.swing.plaf.windows.WindowsLookAndFeel App

- - - -
`%JAVA_HOME%/lib`以下に`swing.properties`を作ってデフォルトの`Look and Feel`を指定する方法もあります。

- [Specifying the Look and Feel: swing.properties File](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html#properties)

<!-- dummy comment line for breaking list -->

- - - -
`SystemLookAndFeel`を使用する場合は、`UIManager.getSystemLookAndFeelClassName()`でその実装クラス名を取得して設定します。

<pre class="prettyprint"><code>try {
  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
} catch (Exception e) {
  e.printStackTrace();
}
</code></pre>

~~`Ubuntu(GNOME)`で、上記のようにシステム`LookAndFeel`を指定すると、`NullPointerException`が発生する場合は、直前に`UIManager.getInstalledLookAndFeels()`を呼んでおくと回避できるようです。~~

- [JDK1.6 で使うと JDK 側のバグ (6389282) に引っかかってしまうのか NPE](http://blogs.sun.com/katakai/entry/omegat_in_mdi_mode)
- [Java6 の痛いバグ… NetBeans デスクトップアプリが Linux で動かず… - Masaki Katakai's Weblog](http://blogs.sun.com/katakai/entry/bad_issue_for_swing_gtk)
- `6u10`で修正済
    - [Bug ID: 6389282 NPE in GTKLookAndFeel.initSystemColorDefaults() on mustang when remote X11 displaying.](https://bugs.openjdk.java.net/browse/JDK-6389282)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Set the Look and Feel](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html)
- [LookAndFeelの一覧を取得する](https://ateraimemo.com/Swing/InstalledLookAndFeels.html)
    - `SwingSet3`からコードを引用したサンプル

<!-- dummy comment line for breaking list -->

## コメント
- スクリーンショットなどを更新。 -- *aterai* 2008-03-28 (金) 21:37:52

<!-- dummy comment line for breaking list -->
