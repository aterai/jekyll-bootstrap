---
layout: post
category: swing
folder: PersistenceService
title: PersistenceServiceを使ってJFrameの位置・サイズを記憶
tags: [ServiceManager, PersistenceService, JFrame, SwingWorker, XMLEncoder, XMLDecoder]
author: aterai
pubdate: 2012-03-26T15:45:39+09:00
description: ServiceManagerからPersistenceServiceを取得し、JFrameなどの位置・サイズの保存、呼び出しを行います。
comments: true
---
## 概要
`ServiceManager`から`PersistenceService`を取得し、`JFrame`などの位置・サイズの保存、呼び出しを行います。

{% download https://lh6.googleusercontent.com/-PyOW5DW5kHU/T3APD_Cq_bI/AAAAAAAABKk/i9eivMuQZ0Y/s800/PersistenceService.png %}

## サンプルコード
<pre class="prettyprint"><code>class LoadSaveTask extends SwingWorker&lt;WindowAdapter, Void&gt; {
  private final WindowState windowState;
  public LoadSaveTask(WindowState windowState) {
    super();
    this.windowState = windowState;
  }
  @Override public WindowAdapter doInBackground() {
    PersistenceService ps;
    BasicService bs;
    try {
      bs = (BasicService) ServiceManager.lookup("javax.jnlp.BasicService");
      ps = (PersistenceService) ServiceManager.lookup("javax.jnlp.PersistenceService");
    } catch (UnavailableServiceException use) {
      ps = null;
      bs = null;
    }
    if (ps == null || bs == null) {
      return null;
    } else {
      final PersistenceService persistenceService = ps;
      final URL codebase = bs.getCodeBase();
      loadWindowState(persistenceService, codebase, windowState);
      return new WindowAdapter() {
        @Override public void windowClosing(WindowEvent e) {
          JFrame f = (JFrame) e.getComponent();
          if (f.getExtendedState() == Frame.NORMAL) {
            windowState.setSize(f.getSize());
            windowState.setLocation(f.getLocationOnScreen());
          }
          saveWindowState(persistenceService, codebase, windowState);
        }
      };
    }
  }
  private static void loadWindowState(
      PersistenceService ps, URL codebase, WindowState windowState) {
    try {
      FileContents fc = ps.get(codebase);
      try (XMLDecoder d = new XMLDecoder(
          new BufferedInputStream(fc.getInputStream()))) {
        @SuppressWarnings("unchecked")
        Map&lt;String, Serializable&gt; map = (Map&lt;String, Serializable&gt;) d.readObject();
        windowState.setSize((Dimension) map.get("size"));
        windowState.setLocation((Point) map.get("location"));
      }
    } catch (IOException ex) {
      try {
        long size = ps.create(codebase, 64000);
        System.out.println("Cache created - size: " + size);
      } catch (IOException ioe) {
        ioe.printStackTrace();
      }
    }
  }
  private static void saveWindowState(
      PersistenceService ps, URL codebase, WindowState windowState) {
    try {
      FileContents fc = ps.get(codebase);
      try (XMLEncoder e = new XMLEncoder(
          new BufferedOutputStream(fc.getOutputStream(true)))) {
        HashMap&lt;String, Serializable&gt; map = new HashMap&lt;&gt;();
        map.put("size", (Serializable) windowState.getSize());
        map.put("location", (Serializable) windowState.getLocation());
        e.writeObject(map);
        e.flush();
      }
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`PersistenceService`で確保したファイルに、`HashMap<String, Serializable>`に格納した`JFrame`の位置、サイズを`XMLEncoder`、`XMLDecoder`を使って読み書きしています。

- - - -
- `Windows 7`、`JDK 1.7.0_03`では、`C:\Users\(user)\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\muffin`以下に`muf`ファイルなどが作成されるようです。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;java version="1.7.0_03" class="java.beans.XMLDecoder"&gt;
 &lt;object class="java.util.HashMap"&gt;
  &lt;void method="put"&gt;
   &lt;string&gt;location&lt;/string&gt;
   &lt;object idref="Point0"/&gt;
  &lt;/void&gt;
  &lt;void method="put"&gt;
   &lt;string&gt;size&lt;/string&gt;
   &lt;object idref="Dimension0"/&gt;
  &lt;/void&gt;
 &lt;/object&gt;
&lt;/java&gt;
</code></pre>

- - - -
- `XMLEncoder`で直接上記の`JFrame`を書きだす場合、以下のような`IllegalAccessException`が発生する

<!-- dummy comment line for breaking list -->

	java.lang.IllegalAccessException: Class sun.reflect.misc.Trampoline can not access a member of class MainPanel$2 with modifiers ""
	Continuing ...

- 回避方法
    - `WindowListener`を実装する匿名内部クラスを`public class`(`Java Beans`)に変更する
    - または、`removeWindowListener`で取り除く
    - または、`XMLEncoder#setExceptionListener(...)`で、何もしない`ExceptionListener`を設定し、警告を捨ててしまう

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//package example;
//-*- mode:java; encoding:utf-8 -*-
// vim:set fileencoding=utf-8:
//@homepage@
import java.awt.*;
import java.awt.event.*;
import java.beans.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import javax.swing.*;

public class MainPanel extends JPanel {
  private static final String PROPERTIES_XML = "properties.xml";
  public MainPanel() {
    super(new BorderLayout());
    JTextArea textArea = new JTextArea();
    try (Reader fr = new InputStreamReader(
        new FileInputStream(PROPERTIES_XML), StandardCharsets.UTF_8)) {
      textArea.read(fr, "File");
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    add(new JScrollPane(textArea));
  }
  public static void main(String... args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (Exception e) {
      e.printStackTrace();
    }
    JFrame frame = loadFrame();
    frame.setVisible(true);
  }
  private static JFrame loadFrame() {
    JFrame frame = null;
    try (XMLDecoder d = new XMLDecoder(new BufferedInputStream(
        new FileInputStream(PROPERTIES_XML)))) {
      frame = (JFrame) d.readObject();
      //d.close();
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    if (frame == null) {
      frame = new JFrame("title");
      frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      frame.getContentPane().add(new MainPanel());
      frame.setSize(320, 240);
      frame.setLocationRelativeTo(null);
    }
    frame.addWindowListener(new WindowAdapter() {
      @Override public void windowClosing(WindowEvent e) {
        JFrame frame = (JFrame) e.getComponent();
        frame.removeWindowListener(this);
        File file = new File(PROPERTIES_XML);
        try (XMLEncoder xe = new XMLEncoder(new BufferedOutputStream(
            new FileOutputStream(file)))) {
          xe.setExceptionListener(new ExceptionListener() {
            @Override public void exceptionThrown(Exception exception) {
              //XXX:
              exception.printStackTrace();
            }
          });
          xe.writeObject(frame);
          //xe.flush(); xe.close();
        } catch (Exception ex) {
          ex.printStackTrace();
        }
      }
    });
    return frame;
  }
}
</code></pre>

## 参考リンク
- [JWS javax.jnlp.* API demos](http://pscode.org/jws/api.html)
- [PersistenceService](http://docs.oracle.com/javase/jp/6/technotes/guides/javaws/developersguide/examples.html#PersistenceService)
- [PersistenceService Demo](http://www.finnw.me.uk/persistencetest.html)
- [JFrameの位置・サイズを記憶する](http://ateraimemo.com/Swing/Preferences.html)
- [JTableのモデルをXMLファイルで保存、復元する](http://ateraimemo.com/Swing/PersistenceDelegate.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JScrollPane` + `JTable` + `DefalutTableModel`を`XMLEncoder`で`XML`書出しする場合のエラーなどについて: [JTable speichern – Byte-Welt Wiki](http://wiki.byte-welt.net/wiki/JTable_speichern) -- *aterai* 2013-11-14 (木) 19:06:49

<!-- dummy comment line for breaking list -->

	java.lang.InstantiationException: javax.swing.plaf.basic.BasicTableHeaderUI$MouseInputHandler
	Continuing ...
	java.lang.Exception: XMLEncoder: discarding statement JTableHeader.removeMouseMotionListener(BasicTableHeaderUI$MouseInputHandler);
	Continuing ...
	java.lang.InstantiationException: javax.swing.plaf.basic.BasicTableUI$Handler
	Continuing ...
	java.lang.Exception: XMLEncoder: discarding statement JTable.removeMouseMotionListener(BasicTableUI$Handler);
	Continuing ...
