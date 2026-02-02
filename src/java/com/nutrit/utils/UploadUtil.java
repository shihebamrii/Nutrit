package com.nutrit.utils;

import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public final class UploadUtil {

    private UploadUtil() {}

    /**
     * Resolves a writable absolute path for a web-relative directory (example: "assets/img")
     * and ensures it exists.
     *
     * Preference order:
     * 1) ServletContext init-param "NUTRIT_UPLOAD_BASE_DIR" (if set) + relativeDir
     * 2) Exploded webapp real path (ServletContext.getRealPath)
     * 3) Fallback under catalina.base (or java.io.tmpdir)
     */
    public static Path ensureUploadDir(ServletContext ctx, String relativeDir) throws IOException {
        String rel = normalizeRelative(relativeDir);

        String base = (ctx != null) ? ctx.getInitParameter("NUTRIT_UPLOAD_BASE_DIR") : null;
        if (base != null && !base.trim().isEmpty()) {
            Path p = Paths.get(base.trim()).resolve(rel);
            Files.createDirectories(p);
            return p.toAbsolutePath().normalize();
        }

        if (ctx != null) {
            String real = ctx.getRealPath("/" + rel);
            if (real != null && !real.trim().isEmpty()) {
                Path p = Paths.get(real);
                Files.createDirectories(p);
                return p.toAbsolutePath().normalize();
            }
        }

        String catalinaBase = System.getProperty("catalina.base");
        if (catalinaBase == null || catalinaBase.isBlank()) {
            catalinaBase = System.getProperty("java.io.tmpdir");
        }
        Path p = Paths.get(catalinaBase, "Nutrit", rel);
        Files.createDirectories(p);
        return p.toAbsolutePath().normalize();
    }

    public static String safeFileName(String submittedFileName) {
        if (submittedFileName == null) return "file";
        // strip any path segments (Windows/Unix)
        String name = submittedFileName.replace("\\", "/");
        int idx = name.lastIndexOf('/');
        if (idx >= 0) name = name.substring(idx + 1);
        // basic sanitization
        name = name.replaceAll("[^a-zA-Z0-9._-]", "_");
        if (name.isBlank()) return "file";
        return name;
    }

    private static String normalizeRelative(String relativeDir) {
        String rel = (relativeDir == null) ? "" : relativeDir.trim();
        while (rel.startsWith("/")) rel = rel.substring(1);
        while (rel.startsWith("\\")) rel = rel.substring(1);
        rel = rel.replace("\\", "/");
        return rel;
    }
}


